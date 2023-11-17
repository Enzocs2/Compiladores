%{

int yylex();
int yyerror(char *s);
int sym[500];

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
%left '+' '-'
%left '*' '/'

%%

program:
program statement '\n'
|
;

statement:
expr { printf("%d\n", $1); }
| ID '=' expr { sym[$1] = $3; }
;

expr:
    NUMEROINTEIRO
    | ID { $$ = sym[$1]; }
    | expr SOMA expr { $$ = $1 + $3; }
    | expr SUBTRACAO expr { $$ = $1 - $3; }
    | expr MULTIPLICACAO expr { $$ = $1 * $3; }
    | expr DIVISAO expr { $$ = $1 / $3; }
    | '(' expr ')' { $$ = $2; }
    ;
%%

int yyerror(char *s){
    printf(stderr, "%s\n", s);

    return 0;
}

int main(){
    yyparse();

    return 0;
}