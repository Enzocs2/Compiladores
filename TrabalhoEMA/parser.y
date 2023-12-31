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
FILE *tokens = NULL;

No *root;
char *var_nome;   

%}

%union{
  No *pont;
}

/* Tipos de tokens */
%token <pont> PRINT
%token <pont> INPUT
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
%token <pont> PARADAFOR
%token <pont> ATRIBUICAOFOR //usados apeanas para printar o código com uma formatação melhor

%token <pont> INT
%token <pont> REAL
%token <pont> CHAR


%token <pont> OPEN_BRACE
%token <pont> CLOSE_BRACE
%token <pont> OPEN_BLOCK
%token <pont> CLOSE_BLOCK

%token <pont> EQ /* == */ 
%token <pont> NE

%type <pont> soma
%type <pont> subtracao
%type <pont> multiplicacao
%type <pont> divisao
%type <pont> restoDiv
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
%type <pont> compMaior
%type <pont> compMenor
%type <pont> compMaiorIgual
%type <pont> compMenorIgual
%type <pont> compOr
%type <pont> compAnd
%type <pont> compNot
%type <pont> paradaFor
%type <pont> atribuicaoFor
%type <pont> comandoInput
%type <pont> comandoPrintint
%type <pont> comandoPrintstring
%type <pont> comandoPrintreal

%right '='
%left  '-' '+'
%left  '*' '/'
%left  '%'

/* Declaracao BISON - regras de gramatica */
%%

programa: lista_comando { root = $1; fprintf(tokens, "ROOT\n");} 

lista_comando: comando EOL { $1->prox = 0; fprintf(tokens, "COMANDO EOL\n");
                                   $$ = $1;
                                 }

              |comando EOL lista_comando { $1->prox = $3; fprintf(tokens, "COMANDO EOL LISTA_COMANDO\n");
	                                         $$ = $1;
	                                       }

              |if_comando lista_comando{ $1->prox = $2; fprintf(tokens, "IF_COMANDO LISTA_COMANDO\n");
	                                         $$ = $1;
	                                       }
              |if_comando{ $1->prox = 0; fprintf(tokens, "IF_COMANDO\n");
	                                         $$ = $1;
	                                       }  
              |for_comando{ $1->prox = 0; fprintf(tokens, "FOR_COMANDO\n");
	                                         $$ = $1;
	                                       }                                                                                  
              |for_comando lista_comando{ $1->prox = $2; fprintf(tokens, "FOR_COMANDO LISTA_COMANDO\n");
	                                         $$ = $1;
	                                       }                                                        
;

bloco: OPEN_BLOCK lista_comando CLOSE_BLOCK { $$ = $2; fprintf(tokens, "OPEN_BLOCK LISTA_COMANDO CLOSE_BLOCK\n"); } 

ident: ID        { $$ = (No*)malloc(sizeof(No)); fprintf(tokens, "ID\n");
          $$->token = ID;
		      strcpy($$->nome, yylval.pont->nome);
		      $$->esq = NULL;
		      $$->dir = NULL;
          $$->prox = NULL;
                    }  

exp: NUMREAL { $$ = (No*)malloc(sizeof(No)); fprintf(tokens, "NUMREAL\n");
      $$->token = NUMREAL;
      $$->rval = $1->rval;
      $$->esq = NULL;
      $$->dir = NULL;
      $$->prox = NULL;
    }
    | NUMINTEIRO { $$ = (No*)malloc(sizeof(No)); fprintf(tokens, "NUMINTEIRO\n");
      $$->token = NUMINTEIRO;
      $$->ival = $1->ival;
      $$->esq = NULL;
      $$->dir = NULL;
      $$->prox = NULL;
    }
    | STRING { $$ = (No*)malloc(sizeof(No)); fprintf(tokens, "STRING\n");
      $$->token = STRING;
      strcpy($$->string, $1->string);
      $$->esq = NULL;
      $$->dir = NULL;
      $$->prox = NULL;
    }
    | ident {fprintf(tokens, "IDENT\n");}
    | soma {fprintf(tokens, "SOMA\n");}
    | subtracao {fprintf(tokens, "SUBTRACAO\n");}
    | divisao {fprintf(tokens,"DIVISAO\n");}
    | multiplicacao {fprintf(tokens,"MULTIPLICACAO\n");}
    | restoDiv {fprintf(tokens,"RESTODIV\n");}
    ;

comando: atribuicao {fprintf(tokens,"ATRIBUICAO\n");}
        | bloco {fprintf(tokens,"BLOCO\n");}
        | if_comando {fprintf(tokens,"IF_COMANDO\n");}
        | for_comando {fprintf(tokens,"FOR_COMANDO\n");}
        | comandoPrintint {fprintf(tokens,"COMANDOPRINTINT\n");}
        | comandoPrintreal {fprintf(tokens,"COMANDOPRINTREAL\n");}
        | comandoPrintstring {fprintf(tokens,"COMANDOPRINTSTRING\n");}
        | comandoInput {fprintf(tokens,"COMANDOINPUT\n");}
;

atribuicao: REAL ident '=' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"REAL IDENT '=' EXP\n");
			    $$->token = '=';
          $$->type = REAL;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          | INT ident '=' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens," INT IDENT '=' EXP\n");
			    $$->token = '=';
          $$->type = INT;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          | CHAR ident '=' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"CHAR IDENT '=' EXP\n");
			    $$->token = '=';
          $$->type = CHAR;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          ;

comparacao: igualdade { fprintf(tokens,"IGUALDADE\n");}
          | diferenca { fprintf(tokens,"DIFERENCA\n");}
          | compMaior { fprintf(tokens,"COMPMAIOR\n");}
          | compMenor { fprintf(tokens,"COMPMENOR\n");}
          | compMaiorIgual { fprintf(tokens,"COMPMAIORIGUAL\n");}
          | compMenorIgual { fprintf(tokens,"COMPMENORIGUAL\n");}
          | compAnd { fprintf(tokens,"COMPAND\n");}
          | compOr { fprintf(tokens,"COMPOR\n");}
          | compNot { fprintf(tokens,"COMPNOT\n");}
;

soma: exp '+' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP '+' EXP\n");
          $$->token = '+';
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
      }
subtracao: exp '-' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP '-' EXP\n");
          $$->token = '-';
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
      }
divisao: exp '/' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP '/' EXP\n");
          $$->token = '/';
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
      }
multiplicacao: exp '*' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP '*' EXP\n");
          $$->token = '*';
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
      }

restoDiv: exp '%' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP '%' EXP\n");
          $$->token = '%';
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
      } 

igualdade: exp EQ exp     { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP EQ EXP\n");
                            $$->token = EQ;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

diferenca: exp NE exp     { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP NE EXP\n");
                            $$->token = NE;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

compMaiorIgual: exp MAIORIGUAL exp     { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP MAIORIGUAL EXP\n");
                            $$->token = MAIORIGUAL;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

compMenorIgual: exp MENORIGUAL exp     { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP MENORIGUAL EXP\n");
                            $$->token = MENORIGUAL;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

compMenor: exp MENOR exp     { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP MENOR EXP\n");
                            $$->token = MENOR;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

compMaior: exp MAIOR exp     { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP MAIOR EXP\n");
                            $$->token = MAIOR;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }                                                                                                        

compAnd: exp AND exp     { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP AND EXP\n");
                            $$->token = AND;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

compOr: exp OR exp     { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"EXP OR EXP\n");
                            $$->token = OR;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          } 

compNot: NOT exp     { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"NOT EXP\n");
                            $$->token = NOT;
			    $$->esq = NULL;
			    $$->dir = $2;
          $$->prox = NULL;
                          }                                                       

if_comando: IF OPEN_BRACE comparacao CLOSE_BRACE bloco
                { $$ = (No*)malloc(sizeof(No));  fprintf(tokens,"IF OPEN_BRACE COMPARACAO CLOSE_BRACE BLOCO\n");
		  $$->token = IF;
		  $$->lookahead = $3;
		  $$->esq = $5;
		  $$->dir = NULL;
      $$->prox = NULL;
                }
           | IF OPEN_BRACE comparacao CLOSE_BRACE bloco ELSE bloco
                { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"IF OPEN_BRACE COMPARACAO CLOSE_BRACE BLOCO\n");
		  $$->token = IF;
		  $$->lookahead = $3;
		  $$->esq = $5;
		  $$->dir = $7;
      $$->prox = NULL;
                }
           ;

paradaFor: REAL ident '=' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"REAL IDENT '=' EXP\n");
			    $$->token = PARADAFOR;
          $$->type = REAL;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          | INT ident '=' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"INT IDENT '=' EXP\n");
			    $$->token = PARADAFOR;
          $$->type = INT;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          | CHAR ident '=' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"CHAR IDENT '=' EXP\n");
			    $$->token = PARADAFOR;
          $$->type = CHAR;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          ;

atribuicaoFor: REAL ident '=' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"REAL IDENT '=' EXP\n");
			    $$->token = ATRIBUICAOFOR;
          $$->type = REAL;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          | INT ident '=' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"INT IDENT '=' EXP\n");
			    $$->token = ATRIBUICAOFOR;
          $$->type = INT;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          | CHAR ident '=' exp { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"CHAR IDENT '=' EXP\n");
			    $$->token = ATRIBUICAOFOR;
          $$->type = CHAR;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          ;

for_comando:  FOR OPEN_BRACE atribuicaoFor EOL comparacao EOL paradaFor CLOSE_BRACE bloco
                     { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"FOR OPEN_BRACE ATRIBUICAOFOR EOL COMPARCAO EOL PARADAFOR CLOSE_BRACE BLOCO\n");
		       $$->token = FOR;
		       $$->lookahead = $3;
		       $$->lookahead1 = $5;
		       $$->lookahead2 = $7;
           $$->dir = $9;
           $$->prox = NULL;
                     }
          ;

comandoPrintint: PRINT OPEN_BRACE INT ident CLOSE_BRACE { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"PRINT OPEN_BRACE INT IDENT CLOSE_BRACE\n");
		       $$->token = PRINT;
           $$->type = INT;
		       $$->esq = $4;
           $$->prox = NULL;
                     }
          ;

comandoPrintreal: PRINT OPEN_BRACE REAL ident CLOSE_BRACE { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"PRINT OPEN_BRACE REAL IDENT CLOSE_BRACE\n");
		       $$->token = PRINT;
           $$->type = REAL;
		       $$->esq = $4;
           $$->prox = NULL;
                     }
          ;

comandoPrintstring: PRINT OPEN_BRACE CHAR ident CLOSE_BRACE { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"PRINT OPEN_BRACE CHAR IDENT CLOSE_BRACE\n");
		       $$->token = PRINT;
           $$->type = CHAR;
		       $$->esq = $4;
           $$->prox = NULL;
                     }
          ;


comandoInput : REAL ident '=' INPUT OPEN_BRACE CLOSE_BRACE { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"REAL IDENT '=' INPUT OPEN_BRACE CLOSE_BRACE\n");
			    $$->token = INPUT;
          $$->type = REAL;
			    $$->esq = $2;
			    $$->dir = NULL;
          $$->prox = NULL;
                          }
          | INT ident '=' INPUT OPEN_BRACE CLOSE_BRACE { $$ = (No*)malloc(sizeof(No)); fprintf(tokens,"INT IDENT '=' INPUT OPEN_BRACE CLOSE_BRACE\n");
			    $$->token = INPUT;
          $$->type = INT;
			    $$->esq = $2;
			    $$->dir = NULL;
          $$->prox = NULL;
                          }
          | CHAR ident '=' INPUT OPEN_BRACE CLOSE_BRACE { $$ = (No*)malloc(sizeof(No)); fprintf(tokens," CHAR IDENT '=' INPUT OPEN_BRACE CLOSE_BRACE\n");
			    $$->token = INPUT;
          $$->type = CHAR;
			    $$->esq = $2;
			    $$->dir = NULL;
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

        case INPUT:

        if (insere_var(root->esq->nome) == 0){
          if(root->type==INT){fprintf(saida,"int %s;\n", root->esq->nome);}
          if(root->type==REAL){fprintf(saida,"double %s;\n", root->esq->nome);}
          if(root->type==CHAR){fprintf(saida,"char* %s;\n", root->esq->nome );}
        }

        if(root->type == INT){
          fprintf(saida, "scanf(\"%%d\", &");          
        }
        if(root->type == CHAR){
          fprintf(saida, "scanf(\"%%s\", &");          
        }
        if(root->type == REAL){
          fprintf(saida, "scanf(\"%%f\", &");          
        }

        imprima(root->esq);
        fprintf(saida, ");\n");
        break;  

      case PARADAFOR:
        if (insere_var(root->esq->nome) == 0){
          if(root->type==INT){fprintf(saida,"int ");}
          if(root->type==REAL){fprintf(saida,"double ");}
          if(root->type==CHAR){fprintf(saida,"char* ");}
        }
        imprima(root->esq);
        fprintf(saida,"=");
        imprima(root->dir);
        break;
        
      case ATRIBUICAOFOR:
        if (insere_var(root->esq->nome) == 0){
          if(root->type==INT){fprintf(saida,"int ");}
          if(root->type==REAL){fprintf(saida,"double ");}
          if(root->type==CHAR){fprintf(saida,"char* ");}
        }
        imprima(root->esq);
        fprintf(saida,"=");
        imprima(root->dir);
        fprintf(saida,";");
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

      case '%':
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
        fprintf(saida,"for (");
        var_nome = nome();
        printf("la0:%d\n", root->lookahead->token);
        imprima(root->lookahead);
        printf("la1:%d\n", root->lookahead1->token);
        imprima(root->lookahead1);
        fprintf(saida,"; ");
        printf("la2:%d\n", root->lookahead2->token);
        imprima(root->lookahead2);
        fprintf(saida,"){\n");
        imprima(root->dir);
        fprintf(saida,"}");
        break;
      
      case PRINT:
        if(root->type == INT){
          fprintf(saida, "printf(\"%%d\", ");          
        }
        if(root->type == CHAR){
          fprintf(saida, "printf(\"%%s\", ");          
        }
        if(root->type == REAL){
          fprintf(saida, "printf(\"%%f\", ");          
        }
        imprima(root->esq);
        fprintf(saida, ");\n");
        break;
           

    default: 
      fprintf(saida,"Desconhecido ! Token = %d (%c) \n", root->token, root->token);
    }
    
    if (root->prox != NULL) {
      imprima(root->prox);
    }
    return;
  }
}

int main(int argc, char *argv[]){
  
  char buffer[256];
  char bufferT[256];

  extern FILE *yyin;

  yylval.pont = (No*)malloc(sizeof(No));

  if (argc < 2){
    printf("Ops! Voce fez alguma coisa errada!\n");
    exit(1);
  }
  
  tokens = fopen("tokens.txt", "w");
  entrada = fopen(argv[1],"r");
  if(!entrada){
    printf("Erro! O arquivo nao pode ser aberto! \n");
    exit(1);
  }

  yyin = entrada;

  strcpy(buffer,argv[1]);
  strcat(buffer,".c");
  
  saida = fopen(buffer,"w");
  if(!saida || !tokens){
    printf("Erro! O arquivo nao pode ser aberto! \n");
    exit(1);
  }

  yyparse();

  fprintf(saida,"#include<stdio.h>\n");
  fprintf(saida,"#include<math.h>\n");
  fprintf(saida,"\nint main(int argc, char *argv[]){\n");
  cria_lista();
  imprima(root);
  fprintf(saida,"\n}\n");

  fclose(tokens);
  fclose(entrada);
  fclose(saida);
}