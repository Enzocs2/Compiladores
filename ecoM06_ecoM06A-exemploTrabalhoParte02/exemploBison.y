/* Definicao da Linguagem */

%{
#include<stdio.h>
#include<math.h> 
#include<stdlib.h>
#include<string.h>

#include "linguagem.h"
#include "var_aleatorio.h"
#include "lista_var.h"

#define YYERROR_VERBOSE  /*fornece uma mensagem de erro mais especifica*/ 

/* prototipo */

void yyerror(char *s);
void imprima(No *root);

FILE *entrada, *saida;

No *root;
char *var_nome;   

%}

%union{
  No *pont;
}

/* Tipos de tokens */
%token <pont> IF
%token <pont> ELSE
%token <pont> WHILE 
%token <pont> IDENT
%token <pont> NUM

%token <pont> OPEN_BRACE
%token <pont> CLOSE_BRACE
%token <pont> OPEN_BLOCK
%token <pont> CLOSE_BLOCK

%token <pont> SEMICOLON 
%token <pont> COMMA

%token <pont> EQ /* == */ 
%token <pont> GQ /* > */
%token <pont> NE

%type <pont> programa
%type <pont> lista_comando
%type <pont> bloco
%type <pont> ident
%type <pont> atribuicao
%type <pont> comando
%type <pont> comparacao
%type <pont> igualdade
%type <pont> if_comando
%type <pont> while_comando
%type <pont> lista_param
%type <pont> diferenca
%type <pont> exp

%right '='
%left  '-' '+'
%left  '*' '/'
%left  '%'

/* Declaracao BISON - regras de gramatica */
%%

programa: lista_comando { root = $1; } 

lista_comando: comando SEMICOLON { $1->prox = 0;
                                   $$ = $1;
                                 }
             | comando SEMICOLON lista_comando { $1->prox = $3;
	                                         $$ = $1;
	                                       }


bloco:  OPEN_BLOCK lista_comando CLOSE_BLOCK { $$ = $1; } 

ident: IDENT        { $$ = (No*)malloc(sizeof(No));
                      $$->token = IDENT;
		      strcpy($$->nome, yylval.pont->nome);
		      $$->esq = NULL;
		      $$->dir = NULL;
                    }  

exp: NUM { $$ = (No*)malloc(sizeof(No));}
    | ident { $$ = (No*)malloc(sizeof(No));}
    ;

atribuicao: ident '=' exp { $$ = (No*)malloc(sizeof(No));
			    $$->token = '=';
			    $$->esq = $1;
			    $$->dir = $3;
                          }
  
lista_param:  exp { $$ = $1; }
           |  exp COMMA lista_param { $$ = (No*)malloc(sizeof(No));
	                              $$->token = COMMA;
				      $$->esq = $1;
				      $$->dir = $3;
                                    } 

comando:  atribuicao
        | bloco
        | if_comando
        | while_comando
;

comparacao: igualdade
          | diferenca
;

igualdade: exp EQ exp     { $$ = (No*)malloc(sizeof(No));
                            $$->token = EQ;
			    $$->esq = $1;
			    $$->dir = $3;
                          }

diferenca: exp NE exp     { $$ = (No*)malloc(sizeof(No));
                            $$->token = NE;
			    $$->esq = $1;
			    $$->dir = $3;
                          }

if_comando:  IF OPEN_BRACE comparacao CLOSE_BRACE bloco
                { $$ = (No*)malloc(sizeof(No));
		  $$->token = IF;
		  $$->lookahead = $3;
		  $$->esq = $5;
		  $$->dir = NULL;
                }
           | IF OPEN_BRACE comparacao CLOSE_BRACE bloco ELSE bloco
                { $$ = (No*)malloc(sizeof(No));
		  $$->token = IF;
		  $$->lookahead = $3;
		  $$->esq = $5;
		  $$->dir = $7;
                }

while_comando:  WHILE OPEN_BRACE comparacao CLOSE_BRACE bloco
                     { $$ = (No*)malloc(sizeof(No));
		       $$->token = WHILE;
		       $$->lookahead = $3;
		       $$->esq = $5;
		       $$->dir = NULL;
                     }

%%

void yyerror(char *s) {
  printf("%s\n", s);
}

void imprima(No *root){

  if (root != NULL){
    switch(root->token){
    case NUM:
      fprintf(saida,"%g", root->val);
      break;

    case IDENT:
      fprintf(saida,"%s", root->nome);
      break;

    case '=':
      if (insere_var(root->esq->nome) == 0){
	fprintf(saida,"double ");
      }
      imprima(root->esq);
      fprintf(saida,"=");
      imprima(root->dir);
      fprintf(saida,";\n");
      break;
      
    case '+':
      imprima(root->esq);
      fprintf(saida,"+");
      imprima(root->dir);
      break;

    case EQ:
      imprima(root->esq);
      fprintf(saida,"==");
      imprima(root->dir);
      break;
      
    case IF:
      fprintf(saida," \nif ");
      fprintf(saida,"(");
      imprima(root->lookahead);
      fprintf(saida,")");
      fprintf(saida," {\n");
      imprima(root->esq);
      fprintf(saida," }");
      
      if(root->dir != NULL){
	fprintf(saida,"\n else");
	fprintf(saida," {\n");
	imprima(root->dir);
	fprintf(saida," }\n");
      }
      else fprintf(saida,"\n");
      break;
      
    case WHILE:
      fprintf(saida," if (rank == 0){");
      var_nome = nome();
      fprintf(saida,"\ndouble %s = ", var_nome);
      fprintf(saida,"Var(");
      imprima(root->lookahead);
      fprintf(saida,");\n");
      fprintf(saida," MPI_Bcast(&%s, 1, MPI_DOUBLE, 0, simCom);\n\n", var_nome);
      fprintf(saida," while ");
      fprintf(saida,"(");
      fprintf(saida,"%s > 0", var_nome);
      fprintf(saida,")");
      fprintf(saida," {\n ");
      imprima(root->esq);
      fprintf(saida," %s--;", var_nome);
      fprintf(saida,"\n }\n");
      fprintf(saida,"\n }\n");
      break;

    default: 
      fprintf(saida,"Desconhecido ! Token = %d (%c) \n", root->token, root->token);
    }
    if (root->prox != NULL) {
      imprima(root->prox);
    }
  }
}

int main(int argc, char *argv[]){
  
  char buffer[256];

  extern FILE *yyin;

  yylval.pont = (No*)malloc(sizeof(No));

  if (argc < 2){
    printf("Ops! Voce fez alguma coisa errada!\n");
    exit(1);
  }
  
  entrada = fopen(argv[1],"r");
  if(!entrada){
    printf("Erro! O arquivo nao pode ser aberto! \n");
    exit(1);
  }

  yyin = entrada;

  strcpy(buffer,argv[1]);
  strcat(buffer,".cc");
  
  saida = fopen(buffer,"w");
  if(!saida){
    printf("Erro! O arquivo nao pode ser aberto! \n");
    exit(1);
  }

  yyparse();

  fprintf(saida,"#include<iostream.h>\n");
  fprintf(saida,"#include<stdio.h>\n");
  fprintf(saida,"#include<math.h>\n");
  fprintf(saida,"\n int main(int argc, char *argv[]){\n");
  cria_lista();
  imprima(root);
  fprintf(saida,"\n}\n");

  fclose(entrada);
  fclose(saida);
}
