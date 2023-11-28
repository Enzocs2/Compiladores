%{
#include "ch3hdr.h"
#include <string.h>

int yylex();
int yyerror(char *s);
%}

%union {
	double dval;
	int ival;
	char c;
	struct symtab *symp;
}

%token SUBTRACAO
%token SOMA
%token DIVISAO
%token MULTIPLICACAO
%token FECHAPARENTESES
%token ABREPARENTESES
%token ATRIBUICAO
%token INT
%token REAL
%token CHAR

%token <symp> NAME
%token <dval> NUMBERREAL
%token <ival> NUMBERINT
%token <c> CARACTERE

%left SUBTRACAO SOMA
%left MULTIPLICACAO DIVISAO
%nonassoc UMINUS

%type <ival> expressionInt
%type <dval> expressionReal
%type <c> letra
%type <c> statementChar
%%
statement_list:	'\n'
	|	statement_list statementInt '\n'
	|	statement_list statementReal '\n'
	|	statement_list statementChar '\n'
	;

letra: CARACTERE
	;


statementChar:CHAR NAME ATRIBUICAO letra	{ $2->cvalue = $4; }
	|	letra		{ printf("= %g\n", $1); }
	;

statementReal:REAL NAME ATRIBUICAO expressionReal	{ $2->dvalue = $4; }
	|	expressionReal		{ printf("= %g\n", $1); }
	;

statementInt:INT NAME ATRIBUICAO expressionInt	{ $2->ivalue = $4; }
	|	expressionInt		{ printf("= %g\n", $1); }
	;

expressionInt:	expressionInt SOMA expressionInt { $$ = $1 + $3; }
	|	expressionInt SUBTRACAO expressionInt { $$ = $1 - $3; }
	|	expressionInt MULTIPLICACAO expressionInt { $$ = $1 * $3; }
	|	expressionInt DIVISAO expressionInt
				{	if($3 == 0.0)
						yyerror("divide by zero");
					else
						$$ = $1 / $3;
				}
	|	SUBTRACAO expressionInt %prec UMINUS	{ $$ = -$2; }
	|	ABREPARENTESES expressionInt FECHAPARENTESES	{ $$ = $2; }
	|	NUMBERINT
	|	NAME			{ $$ = $1->ivalue; }
	;

expressionReal:	expressionReal SOMA expressionReal { $$ = $1 + $3; }
	|	expressionReal SUBTRACAO expressionReal { $$ = $1 - $3; }
	|	expressionReal MULTIPLICACAO expressionReal { $$ = $1 * $3; }
	|	expressionReal DIVISAO expressionReal
				{	if($3 == 0.0)
						yyerror("divide by zero");
					else
						$$ = $1 / $3;
				}
	|	SUBTRACAO expressionReal %prec UMINUS	{ $$ = -$2; }
	|	ABREPARENTESES expressionReal FECHAPARENTESES	{ $$ = $2; }
	|	NUMBERREAL
	|	NAME			{ $$ = $1->ivalue; }
	;

%%

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}

/* look up a symbol table entry, add if not present */
struct symtab *
symlook(s)
char *s;
{
	char *p;
	struct symtab *sp;
	
	for(sp = symtab; sp < &symtab[NSYMS]; sp++) {
		/* is it already here? */
		if(sp->name && !strcmp(sp->name, s))
			return sp;
		
		/* is it free */
		if(!sp->name) {
			sp->name = strdup(s);
			return sp;
		}
		/* otherwise continue to next */
	}
	yyerror("Too many symbols");
	exit(1);	/* cannot continue */
} /* symlook */

int main(int argc, char* argv[]){
    yyparse();
    return 0;
}
