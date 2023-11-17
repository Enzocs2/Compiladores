%{

#include "teste.tab.h"

%}
/*
INT [0-9]+
REAL [0-9]+'.'[0-9]+
CHAR '.'
*/  

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


[0-9]+[.][0-9]+ {return NUMEROREAL;}
[0-9]+ {return NUMEROINTEIRO;}
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

<<<<<<< Updated upstream
"{" {return INICIOBLOCO;}
"}" {return FIMBLOCO;}
=======
inicio {printf("Token inicio identificado");}
int {printf("Token inteiro identificado");}
char {printf("Token char identificado");}
real {printf("Token real identificado");}
>>>>>>> Stashed changes

inicio {return INICIO;}
int {return INT;}
char {return CHAR;}
real {return REAL;}

[a-z_][a-zA-Z0-9_]* {return ID;}

%%

/*





*/

int yywrap(void){}
  
int main()
{   
    // The function that starts the analysis
    yylex();

    return 0;
}