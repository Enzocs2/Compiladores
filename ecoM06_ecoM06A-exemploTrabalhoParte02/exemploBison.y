/* Definicao da Linguagem */
%{
#include<stdio.h>
#include<math.h> 
#include<stdlib.h>
#include<string.h>

#include "linguagem.h"
#include "var_aleatorio.h"
#include "lista_var.h"

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
%token <pont> FOR
%token <pont> ID
%token <pont> NUMINTEIRO
%token <pont> NUMREAL
%token <pont> STRING
%token <pont> EOL
%token <pont> MAIORIGUAL
%token <pont> MENORIGUAL
%token <pont> MENOR
%token <pont> MAIOR
%token <pont> AND
%token <pont> OR
%token <pont> NOT
%token <pont> MOD

%token <pont> INT
%token <pont> REAL
%token <pont> CHAR


%token <pont> OPEN_BRACE
%token <pont> CLOSE_BRACE
%token <pont> OPEN_BLOCK
%token <pont> CLOSE_BLOCK

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
%type <pont> for_comando
%type <pont> diferenca
%type <pont> exp
%type <pont> soma
%type <pont> subtracao
%type <pont> divisao
%type <pont> multiplicacao
%type <pont> restoDiv
%type <pont> compMaior
%type <pont> compMenor
%type <pont> compMaiorIgual
%type <pont> compMenorIgual
%type <pont> compOr
%type <pont> compAnd
%type <pont> compNot

%right '='
%left  '-' '+'
%left  '*' '/'
%left  '%'

/* Declaracao BISON - regras de gramatica */
%%

programa: lista_comando { root = $1; printf("root\n");} 

lista_comando: comando EOL lista_comando { $1->prox = $3; printf("lista_comanda\n");
	                                         $$ = $1;
	                                       }
              |comando EOL { $1->prox = 0; printf("lista_comando\n");
                                   $$ = $1;
                                 }
              |if_comando lista_comando{ $1->prox = $2; printf("lista_comanda\n");
	                                         $$ = $1;
	                                       }
              |if_comando{ $1->prox = 0; printf("lista_comanda\n");
	                                         $$ = $1;
	                                       }                                          


bloco: OPEN_BLOCK lista_comando CLOSE_BLOCK { $$ = $2; printf("bloco\n"); } 

ident: ID        { $$ = (No*)malloc(sizeof(No)); printf("ident\n");
          $$->token = ID;
		      strcpy($$->nome, yylval.pont->nome);
		      $$->esq = NULL;
		      $$->dir = NULL;
          $$->prox = NULL;
                    }  

exp: NUMREAL { $$ = (No*)malloc(sizeof(No)); printf("exp\n");
      $$->token = NUMREAL;
      $$->rval = $1->rval;
      $$->esq = NULL;
      $$->dir = NULL;
      $$->prox = NULL;
    }
    | NUMINTEIRO { $$ = (No*)malloc(sizeof(No)); printf("exp\n");
      $$->token = NUMINTEIRO;
      $$->ival = $1->ival;
      $$->esq = NULL;
      $$->dir = NULL;
      $$->prox = NULL;
    }
    | STRING { $$ = (No*)malloc(sizeof(No)); printf("exp\n");
      $$->token = STRING;
      strcpy($$->string, $1->string);
      $$->esq = NULL;
      $$->dir = NULL;
      $$->prox = NULL;
    }
    | ident {printf("expIdent\n");}
    | soma {printf("exp\n");}
    | subtracao {printf("exp\n");}
    | divisao {printf("exp\n");}
    | multiplicacao {printf("exp\n");}
    | restoDiv
    ;

atribuicao: REAL ident '=' exp { $$ = (No*)malloc(sizeof(No)); printf("atribuicao\n");
			    $$->token = '=';
          $$->type = REAL;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          | INT ident '=' exp { $$ = (No*)malloc(sizeof(No)); printf("atribuicao\n");
			    $$->token = '=';
          $$->type = INT;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          | CHAR ident '=' exp { $$ = (No*)malloc(sizeof(No)); printf("atribuicao\n");
			    $$->token = '=';
          $$->type = CHAR;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          ;

comando: atribuicao {printf("comando\n");}
        | bloco {printf("comando\n");}
        | if_comando {printf("comando\n");}
        | for_comando {printf("comando\n");}
;

comparacao: igualdade {printf("comparacao\n");}
          | diferenca {printf("comparacao\n");}
          | compMaior {printf("comparacao\n");}
          | compMenor {printf("comparacao\n");}
          | compMaiorIgual {printf("comparacao\n");}
          | compMenorIgual {printf("comparacao\n");}
          | compAnd
          | compOr
          | compNot
;

soma: exp '+' exp { $$ = (No*)malloc(sizeof(No));
          $$->token = '+';
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
      }

subtracao: exp '-' exp { $$ = (No*)malloc(sizeof(No));
          $$->token = '-';
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
      }

divisao: exp '/' exp { $$ = (No*)malloc(sizeof(No));
          $$->token = '/';
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
      }

multiplicacao: exp '*' exp { $$ = (No*)malloc(sizeof(No));
          $$->token = '*';
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
      }

restoDiv: exp MOD exp { $$ = (No*)malloc(sizeof(No));
          $$->token = MOD;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
      }      


igualdade: exp EQ exp     { $$ = (No*)malloc(sizeof(No)); printf("igualdade\n");
                            $$->token = EQ;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

diferenca: exp NE exp     { $$ = (No*)malloc(sizeof(No)); printf("diferenca\n");
                            $$->token = NE;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

compMaiorIgual: exp MAIORIGUAL exp     { $$ = (No*)malloc(sizeof(No)); printf("diferenca\n");
                            $$->token = MAIORIGUAL;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

compMenorIgual: exp MENORIGUAL exp     { $$ = (No*)malloc(sizeof(No)); printf("diferenca\n");
                            $$->token = MENORIGUAL;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

compMenor: exp MENOR exp     { $$ = (No*)malloc(sizeof(No)); printf("diferenca\n");
                            $$->token = MENOR;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

compMaior: exp MAIOR exp     { $$ = (No*)malloc(sizeof(No)); printf("diferenca\n");
                            $$->token = MAIOR;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }                                                                                                        

compAnd: exp AND exp     { $$ = (No*)malloc(sizeof(No)); printf("diferenca\n");
                            $$->token = AND;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

compOr: exp OR exp     { $$ = (No*)malloc(sizeof(No)); printf("diferenca\n");
                            $$->token = OR;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          } 

compNot: NOT exp     { $$ = (No*)malloc(sizeof(No)); printf("diferenca\n");
                            $$->token = NOT;
			    $$->esq = NULL;
			    $$->dir = $2;
          $$->prox = NULL;
                          }                                                       

if_comando: IF OPEN_BRACE comparacao CLOSE_BRACE bloco
                { $$ = (No*)malloc(sizeof(No)); printf("IF\n");
		  $$->token = IF;
		  $$->lookahead = $3;
		  $$->esq = $5;
		  $$->dir = NULL;
      $$->prox = NULL;
                }
           | IF OPEN_BRACE comparacao CLOSE_BRACE bloco ELSE bloco
                { $$ = (No*)malloc(sizeof(No)); printf("if else\n");
		  $$->token = IF;
		  $$->lookahead = $3;
		  $$->esq = $5;
		  $$->dir = $7;
      $$->prox = NULL;
                }
           ;

for_comando:  FOR OPEN_BRACE atribuicao comparacao EOL atribuicao CLOSE_BRACE bloco
                     { $$ = (No*)malloc(sizeof(No)); printf("for\n");
		       $$->token = FOR;
		       $$->lookahead = $3;
		       $$->lookahead1 = $4;
		       $$->lookahead2 = $5;
           $$->dir = $7;
           $$->prox = NULL;
                     }
          ;

%%

void yyerror(char *s) {
  printf("%s\n", s);
}

void imprima(No *root){
  printf("token: %d\n", root->token);
  if(root == NULL){
    printf("null\n");
  }
  if (root != NULL){
    
    switch(root->token){
      case NUMREAL:
        fprintf(saida,"%g", root->rval);
        break;
      
      case NUMINTEIRO:
        fprintf(saida,"%d", root->ival);
        break;

      case STRING:
        fprintf(saida,"%s", root->string);
        break;

      case ID:
        fprintf(saida,"%s", root->nome);
        printf("%s", root->nome);
        break;

      case '=':
        if (insere_var(root->esq->nome) == 0){
          if(root->type==INT){fprintf(saida,"int ");}
          if(root->type==REAL){fprintf(saida,"double ");}
          if(root->type==CHAR){fprintf(saida,"char* ");}
        }
        imprima(root->esq);
        fprintf(saida,"=");
        imprima(root->dir);
        fprintf(saida,";\n");
        break;
        
      case '+':
        printf("%d", root->token);
        imprima(root->esq);
        fprintf(saida,"+");
        imprima(root->dir);
        break;

      case '-':
        printf("%d", root->token);
        imprima(root->esq);
        fprintf(saida,"-");
        imprima(root->dir);
        break;

      case '*':
        printf("%d", root->token);
        imprima(root->esq);
        fprintf(saida,"*");
        imprima(root->dir);
        break;  

      case '/':
        printf("%d", root->token);
        imprima(root->esq);
        fprintf(saida,"/");
        imprima(root->dir);
        break;  

      case MOD:
        printf("%d", root->token);
        imprima(root->esq);
        fprintf(saida,"%%");
        imprima(root->dir);
        break; 

      case EQ:
        imprima(root->esq);
        fprintf(saida,"==");
        imprima(root->dir);
        break;

      case NE:
        imprima(root->esq);
        fprintf(saida,"!=");
        imprima(root->dir);
        break;  

      case MAIOR:
        imprima(root->esq);
        fprintf(saida,">");
        imprima(root->dir);
        break; 

      case MENOR:
        imprima(root->esq);
        fprintf(saida,"<");
        imprima(root->dir);
        break;
        
      case MENORIGUAL:
        imprima(root->esq);
        fprintf(saida,"<=");
        imprima(root->dir);
        break; 

      case MAIORIGUAL:
        imprima(root->esq);
        fprintf(saida,">=");
        imprima(root->dir);
        break;

      case OR:
        imprima(root->esq);
        fprintf(saida,"||");
        imprima(root->dir);
        break;

      case AND:
        imprima(root->esq);
        fprintf(saida,"&&");
        imprima(root->dir);
        break;

      case NOT:
        fprintf(saida,"!");
        imprima(root->dir);
        break;                    

      case IF:
        fprintf(saida," \nif ");
        fprintf(saida,"(");
        imprima(root->lookahead);
        fprintf(saida,")");
        fprintf(saida," {\n");
        imprima(root->esq);
        fprintf(saida,"}");
        
        if(root->dir != NULL){
        fprintf(saida,"\n else");
        fprintf(saida," {\n");
        imprima(root->dir);
        fprintf(saida," }\n");
        }
        else fprintf(saida,"\n");
        break;
        
      case FOR:
        fprintf(saida,"while (");
        var_nome = nome();
        imprima(root->lookahead);
        imprima(root->lookahead1);
        imprima(root->lookahead2);
        fprintf(saida,"){\n");
        imprima(root->dir);
        fprintf(saida,"}");
        break;

    default: 
      fprintf(saida,"Desconhecido ! Token = %d (%c) \n", root->token, root->token);
    }
    
    if (root->prox != NULL) {
      printf("aqui\n");
      imprima(root->prox);
    }
    return;
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

  fprintf(saida,"#include<iostream>\n");
  fprintf(saida,"#include<stdio.h>\n");
  fprintf(saida,"#include<math.h>\n");
  fprintf(saida,"\nint main(int argc, char *argv[]){\n");
  cria_lista();
  imprima(root);
  fprintf(saida,"\n}\n");

  fclose(entrada);
  fclose(saida);
}
