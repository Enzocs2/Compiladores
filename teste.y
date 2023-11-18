%{
#include<unordered_map>

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

tr1::unordered_map<variavel.id,variavel> varTable;

%}

%union {
    int inteiro; /* integer value */
    double real; /* symbol table index */
    char caractere;
    variavel var;
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

calcInt: ID ATRIBUICAO exprInt {varTable[$1] = $3.variavel.numInteiro.n}
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


