%{

int yylex();
int yyerror(char *s);

%}

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
%token NUMEROINTEIRO
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

%token ID

%%

input: ATRIBUICAO;

%%

int yyerror(char *s){
    printf("ERROR: %s\n", s);

    return 0;
}

int main(){
    yyparse();

    return 0;
}