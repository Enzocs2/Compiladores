%{

%}
/*
INT [0-9]+
REAL [0-9]+'.'[0-9]+
CHAR '.'
*/  

%%
= {printf("ATRIBUICAO");}
input {printf("ENTRADA");}
print {printf("SAIDA");}
if {printf("CONDICIONAL");}
else {printf("DESVIOCONDICIONAL");}
elseif {printf("DESVIOANINHADO");}
for {printf("LACO");}


[<] {printf("MENOR");} /*Mudei pra ter token de <, =, >, !*/
> {printf("MAIOR");}
! {printf("NOT");}


[0-9]+[.][0-9]+ {printf("NUMEROREAL");}
[0-9]+ {printf("NUMEROINTEIRO");}
'.' {printf("CHARACTERE");}

and {printf("AND");}
or {printf("OR");}

[.] {printf("PONTOFINAL");}
[:] {printf("DOISPONTOS");}
[(] {printf("ABREPARENTESES");}
[)] {printf("FECHAPARENTESES");}

[+] {printf("SOMA");}
- {printf("SUBTRACAO");}
[*] {printf("MULTIPLICACAO");}
[/] {printf("DIVISAO");}
% {printf("MOD");}

[{] {printf("INICIOBLOCO");}
[}] {printf("FIMBLOCO");}

inicio {printf("INICIO");}
int {printf("INT");}
char {printf("CHAR");}
real {printf("REAL");}

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