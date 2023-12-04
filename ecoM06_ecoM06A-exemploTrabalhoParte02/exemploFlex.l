%{
#include<math.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include "linguagem.h"
#include "exemploBison.tab.h"

%}

%%
[\n]        {}
[ \t]           ; // ignore whitespace

"if"         { return IF; printf("if\n"); } 

"else"       { return ELSE; printf("else\n"); } 

"for"      { return FOR; printf("while\n"); } 
 
"int"       { return INT; }

"real"       { return REAL; }

"char"       { return CHAR; }

"and"  { return AND; }
"or"   { return OR; }

[-|+]?[0-9]+(\.[0-9]+) { yylval.pont->rval = atof(yytext);
                                           return NUMREAL;
                                         }

[-|+]?[0-9]+ { yylval.pont->ival = atoi(yytext);
                                           return NUMINTEIRO;
                                         }
\".*\" { strncpy(yylval.pont->string, yytext, 256);
                                           return STRING;
                                         }                                         

[a-zA-Z][a-zA-z0-9]* { strncpy(yylval.pont->nome, yytext, 256);
                       return ID;
                     }

"print" { return PRINT; }
"input" { return INPUT; }
"!"    { return NOT; }
"=="   { return EQ; }
"!="   { return NE; }
"<="   { return MENORIGUAL; }
">="   { return MAIORIGUAL; }
"<"    { return MENOR; }
">"    { return MAIOR; }
"("    { return OPEN_BRACE; }
")"    { return CLOSE_BRACE; }
"{"    { return OPEN_BLOCK; }
"}"    { return CLOSE_BLOCK; }
";"    { return EOL; }

"="|"+"|"-"|"*"|"/"|"%" { return *yytext; }

.      { return *yytext; }

%% 
int yywrap(void){
  return 1; 
}  
