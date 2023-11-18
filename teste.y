
%{
#include <stdio.h>
#include <stdlib.h>
    extern FILE *yyin;
    int yylex();
    int yyerror(char *s);
    char* sym[500];

%}

%union {
    int iValue; /* integer value */
    char* sIndex; /* symbol table index */
    //nodeType nPtr; /* node pointer */
};

%token ENTRADA
%token ATRIBUICAO
%token SAIDA
%token CONDICIONAL
%token DESVIOCONDICIONAL
%token DESVIOANINHADO
%token LACO

%token MENOR
%token MAIOR
%token NOT

%token NUMEROREAL
%token <iValue> NUMEROINTEIRO
%token CHARACTERE

%token AND
%token OR

%token PONTOFINAL
%token DOISPONTOS
%token ABREPARENTESES
%token FECHAPARENTESES

%token SOMA
%token SUBTRACAO
%token MULTIPLICACAO
%token DIVISAO
%token MOD

%token INICIOBLOCO
%token FIMBLOCO

%token INICIO
%token INT
%token CHAR
%token REAL

%token <sIndex> ID

%left SOMA SUBTRACAO
%left MULTIPLICACAO DIVISAO

%type <iValue> expr

%%

input:
    |input line
    ;

line:
    '\n'
    |expr '\n'  { printf("resultado: %d\n", $1); }
    ;

expr:
    NUMEROINTEIRO { $$ = $1;}
    | expr SOMA expr {  $$ = $1 + $3; printf("%d + %d = %d\n", $1, $3, $$); }
    | expr SUBTRACAO expr { $$ = $1 - $3; }
    | expr MULTIPLICACAO expr { $$ = $1 * $3; }
    | expr DIVISAO expr { $$ = $1 / $3; }
    | ABREPARENTESES expr FECHAPARENTESES { $$ = $2; }
    ;
%%

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}

int main(int argc, char* argv[]){
    yyparse();
    return 0;
}


