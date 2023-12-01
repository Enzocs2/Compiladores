%{
#include<math.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include "linguagem.h"
#include "exemploBison.tab.h"

%}

%%
[\n]        { return EOL; }
[ \t]           ; // ignore whitespace

"if"         { return IF; } 

"else"       { return ELSE; } 

"while"      { return WHILE; } 
 
"int"       { return INT; }

"real"       { return REAL; }

"char"       { return CHAR; }

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

"=="   { return EQ; }
"!="   { return NE; }
"("    { return OPEN_BRACE; }
")"    { return CLOSE_BRACE; }
"{"    { return OPEN_BLOCK; }
"}"    { return CLOSE_BLOCK; }
","    { return COMMA; }

"="|"+"|"-"|"*"|"/"|"%" { return *yytext; }

.      { return *yytext; }

%% 
int yywrap(void){
  return 1; 
}  
