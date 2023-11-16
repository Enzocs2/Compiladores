%{

%}
/*
INT [0-9]+
REAL [0-9]+'.'[0-9]+
CHAR '.'
*/  

%%
= {printf("Token de atribuicao identificado");}
input {printf("Token de entrada identificado");}
print {printf("Token de saida identificado");}
if {printf("Token de condicional identificado");}
else {printf("Token de desvio condicional identificado");}
elseif {printf("Token de desvio aninhado identificado");}
for {printf("Token de laco identificado");}


[<] {printf("Token menor identificado");} /*Mudei pra ter token de <, =, >, !*/
> {printf("Token maior identificado");}
! {printf("Token not identificado");}


[0-9]+[.][0-9]+ {printf("Real identificado");}
[0-9]+ {printf("Inteiro identificado");}
'.' {printf("Char identificado");}

and {printf("Token and identificado");}
or {printf("Token or identificado");}

[+] {printf("Token soma identificado");}
- {printf("Token subtracao identificado");}
[*] {printf("Token multiplicacao identificado");}
[/] {printf("Token divisao identificado");}
% {printf("Token mod identificado");}

{ {printf("Token inicioBloco identificado");}
} {printf("Token fimBloco identificado");}

inicio {printf("Token inicio identificado");}
interio {printf("Token inteiro identificado");}
character {printf("Token char identificado");}
real {printf("Token real identificado");}

[a-z_][a-zA-Z0-9_]* {printf("Variavel identificado");}

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