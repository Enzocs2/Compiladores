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

"while"      { return WHILE; printf("while\n"); } 
 
"int"       { return INT; }

"real"       { return REAL; }

"char"       { return CHAR; }

[-|+]?[0-9]+(\.[0-9]+) { yylval.pont->rval = atof(yytext);  printf("numeroreal\n");
                                           return NUMREAL;
                                         }

[-|+]?[0-9]+ { yylval.pont->ival = atoi(yytext); printf("numerointeiro\n");
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
";"    { return EOL; }

"="|"+"|"-"|"*"|"/"|"%" { return *yytext; }

.      { return *yytext; }

%% 
int yywrap(void){
  return 1; 
}  
