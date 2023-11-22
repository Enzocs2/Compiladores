
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAXTABLE 100

typedef struct{
    char id[30];
    int n;
}numeroInteiro;

typedef struct{
    char id[30];
    double n;
}numeroReal;

typedef struct{
    char id[30];
    char c;
}letras;

typedef union{

    numeroInteiro numInteiro;
    numeroReal numReal;
    letras letra;

}variavel;


extern FILE *yyin;
int yylex();
int yyerror(char *s);

int intCount=0;
numeroInteiro intTable[MAXTABLE];
int realCount=0;
numeroReal realTable[MAXTABLE];
int letraCount=0;
letras letraTable[MAXTABLE];

double lookupIntVariable(char id[30]) {
	int i = 0;
    for (i = 0; i <= MAXTABLE; i++) {
        if (strcmp(intTable[i].id, id) == 0) {
            return intTable[i].n;
        }
    }
    fprintf(stderr, "Error: Variable not found\n");
    exit(EXIT_FAILURE);
}

void update_Intvariable(char var[20], int n) {
	int i = 0;
    for (i = 0; i <= intCount; i++) {
        if (strcmp(intTable[i].id, var) == 0) {
            intTable[i].n = n;
            return;
        }
    }
    if (intCount < MAXTABLE) {
        strcpy(intTable[intCount].name, var);
        intTable[intCount].n = n;
        intCount += 1;
		return;
    } else {
        fprintf(stderr, "Error: Maximum number of variables reached\n");
        exit(EXIT_FAILURE);
    }
}

%}

%union {
    int inteiro;
    double real;
    char caractere;
    struct numeroInteiro numInteiro;
    struct numeroReal numReal;
    struct letras letra;
    //nodeType nPtr; /* node pointer */
}

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

%token <real> NUMEROREAL
%token <inteiro> NUMEROINTEIRO
%token <caractere> CHARACTERE

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

%token <var> ID

%left OR
%left AND

%left SOMA SUBTRACAO
%left MULTIPLICACAO DIVISAO


%type <inteiro> exprInt
%type <real> exprReal

%%

input:
    |input line
    ;

line:
    '\n'
    |exprInt '\n'  { printf("resultado: %d\n", $1); }
    ;

calcInt: ID ATRIBUICAO exprInt {intTable[$1] = $3.variavel.numInteiro.n}
    |exprInt
    ;

exprInt:
    NUMEROINTEIRO { $$ = $1;}
    | exprInt SOMA exprInt {  $$ = $1 + $3; printf("%d + %d = %d\n", $1, $3, $$); }
    | exprInt SUBTRACAO exprInt { $$ = $1 - $3; }
    | exprInt MULTIPLICACAO exprInt { $$ = $1 * $3; }
    | exprInt DIVISAO exprInt { $$ = $1 / $3; }
    | ABREPARENTESES exprInt FECHAPARENTESES { $$ = $2; }
    ;

exprReal:
    NUMEROINTEIRO { $$ = $1;}
    | exprReal SOMA exprReal {  $$ = $1 + $3; }
    | exprReal SUBTRACAO exprReal { $$ = $1 - $3; }
    | exprReal MULTIPLICACAO exprReal { $$ = $1 * $3; }
    | exprReal DIVISAO exprReal { $$ = $1 / $3; }
    | ABREPARENTESES exprReal FECHAPARENTESES { $$ = $2; }
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


