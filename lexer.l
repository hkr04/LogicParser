%{
#include "parser.tab.h" 
#include <string.h>
%}

%%

"&&"           { return AND; }
"||"           { return OR; }
"!"            { return NOT; }
"<"            { return LT; }
"<="           { return LE; }
">"            { return GT; }
">="           { return GE; }
"=="           { return EQ; }
"!="           { return NE; }
[0-9]+         { yylval.value = atoi(yytext); return NUMBER; }
[ ]+           ; // skip whitespace
[\r\n]         { return EOF;}
.              { return *yytext; }

%%
int yywrap(void)
{
	return 1;
}
