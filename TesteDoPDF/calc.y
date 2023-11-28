%{
#include "ch3hdr.h"
#include <string.h>

int yylex();
int yyerror(char *s);
%}

%union {
	double dval;
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

%token <symp> NAME
%token <dval> NUMBER
%left SUBTRACAO SOMA
%left MULTIPLICACAO DIVISAO
%nonassoc UMINUS

%type <dval> expression

%%
statement_list:	statementInt '\n'
	|	statement_list statementInt '\n'
	;

statementInt:INT NAME ATRIBUICAO expression	{ $2->ivalue = $4; }
	|	expression		{ printf("= %g\n", $1); }
	;

expression:	expression SOMA expression { $$ = $1 + $3; }
	|	expression SUBTRACAO expression { $$ = $1 - $3; }
	|	expression MULTIPLICACAO expression { $$ = $1 * $3; }
	|	expression DIVISAO expression
				{	if($3 == 0.0)
						yyerror("divide by zero");
					else
						$$ = $1 / $3;
				}
	|	SUBTRACAO expression %prec UMINUS	{ $$ = -$2; }
	|	ABREPARENTESES expression FECHAPARENTESES	{ $$ = $2; }
	|	NUMBER
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
