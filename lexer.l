%{
#include "parser.tab.h" 
#include <string.h>

int yylineno = 1;
int yycolno = 1;
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
"("            { return LBRACE;}
")"            { return RBRACE;}
[0-9]+         { yylval.value = atoi(yytext); return NUMBER; }
[ ]+           ; // skip whitespace
\n             { yylineno++; return EOL;}
.              { yycolno++; return *yytext; }

%%
int yywrap(void)
{
	return 1;
}
