%{
#include "calc.tab.h"
#include "ch3hdr.h"
#include <math.h>
%}

%%

"int" {return INT;}
"char" {return CHAR;}
"real" {return REAL;} 

"+" {return SOMA;}
"-" {return SUBTRACAO;}
"/" {return DIVISAO;}
"*" {return MULTIPLICACAO;}
"=" {return ATRIBUICAO;}
"(" {return ABREPARENTESES;}
")" {return FECHAPARENTESES;}

([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?) {
		yylval.dval = atof(yytext);
		return NUMBER;
	}

[ \t]	;		 /* ignore white space */

[A-Za-z][A-Za-z0-9]*	{	/* return symbol pointer */
		yylval.symp = symlook(yytext);
		return NAME;
	}

"$"	{ return 0; }

\n	|
.	return yytext[0];

%%

int yywrap(void){
    return 1;    
}
