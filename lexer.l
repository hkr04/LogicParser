%{
#include "parser.tab.h" 
#include <string.h>

extern int yycolno;
%}

%%

"&&"           { yycolno += 2; return AND; }
"||"           { yycolno += 2; return OR; }
"!"            { yycolno += 1; return NOT; }
"<"            { yycolno += 1; return LT; }
"<="           { yycolno += 2; return LE; }
">"            { yycolno += 1; return GT; }
">="           { yycolno += 2; return GE; }
"=="           { yycolno += 2; return EQ; }
"!="           { yycolno += 2; return NE; }
"("            { yycolno += 1; return LBRACE;}
")"            { yycolno += 1; return RBRACE;}
[+|-]?[0-9]+   { yycolno += strlen(yytext); yylval.value = atoi(yytext); return NUM; }
[ ]+           { yycolno += strlen(yytext);}
\n             { yycolno++; return EOL;}
.              { yycolno++; return *yytext; }

%%
int yywrap(void) {
	return 1;
}
