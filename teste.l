%{

#include "teste.tab.h"
#include <stdlib.h>


/*
INT [0-9]+
REAL [0-9]+'.'[0-9]+
CHAR '.'


*/

%}

%%
[\n]        { return *yytext; }
[ \t]           ; // ignore whitespace

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


[0-9]+[.][0-9]+ { return NUMEROREAL;}
(-)?[0-9]+ {    yylval.variavel.numInteiro.n = atoi(yytext);
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

[a-z_]([a-z_]|[A-Z]|[0-9])* {   yylval.sIndex = strdup(yytext);
              return ID;}

%%

int yywrap(void){
    return 1;    
}
