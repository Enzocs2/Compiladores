%{

#include "teste.tab.h"
#include <stdlib.h>

/*
INT [0-9]+
REAL [0-9]+'.'[0-9]+
CHAR '.'

\n {return EOL;}
*/

%}

%%
= {return ATRIBUICAO;}
input {return ENTRADA;}
print {return SAIDA;}
if {return CONDICIONAL;}
else {return DESVIOCONDICIONAL;}
elseif {return DESVIOANINHADO;}
for {return LACO;}


"<" {return MENOR;} /*Mudei pra ter token de <, =, >, !*/
> {return MAIOR;}
! {return NOT;}


[0-9]+[.][0-9]+ {   yylval = atof(yytext);
                    return NUMEROREAL;}
[0-9]+ {    yylval = atoi(yytext);
            return NUMEROINTEIRO;}
'.' {return CHARACTERE;}
[''] {return CHARACTERE;}

and {return AND;}
or {return OR;}

"." {return PONTOFINAL;}
":" {return DOISPONTOS;}
"(" {return ABREPARENTESES;}
")" {return FECHAPARENTESES;}

"+" {return SOMA;}
- {return SUBTRACAO;}
"*" {return MULTIPLICACAO;}
"/" {return DIVISAO;}
% {return MOD;}

"{" {return INICIOBLOCO;}
"}" {return FIMBLOCO;}

inicio {return INICIO;}
int {return INT;}
char {return CHAR;}
real {return REAL;}

[a-z|A-Z][a-z|A-Z|0-9]* {return ID;}

%%

int yywrap(void){}
  
int main()
{   
    // The function that starts the analysis
    yylex();

    return 0;
}