%{
#include<math.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include "linguagem.h"
#include "exemploBison.tab.h"

%}

%%
"if"         { return IF; } 

"else"       { return ELSE; } 

"while"      { return WHILE; } 
 
 "int"       { return INT; }

[-+]?[0-9]+("."[0-9]*)?([eE]"-"?[0-9]*)? { yylval.pont->val = atof(yytext);
                                           return NUM;
                                         }
[a-zA-Z][a-zA-z0-9]* { strncpy(yylval.pont->nome, yytext, 256);
                       return IDENT;
                     }

"=="   { return EQ; }
"!="   { return NE; }
"("    { return OPEN_BRACE; }
")"    { return CLOSE_BRACE; }
"{"    { return OPEN_BLOCK; }
"}"    { return CLOSE_BLOCK; }
";"    { return SEMICOLON; }
","    { return COMMA; }

"="|"+"|"-"|"*"|"/"|"%" { return *yytext; }

[ \t\n]  /* Ignora */
.      { return *yytext; }

%% 
int yywrap(void){
  return 1; 
}  
