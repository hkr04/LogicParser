%{
#include <stdio.h>
#include <string.h>

int yylineno = 1;
int yycolno = 0;

void yyerror(const char *s);
int yylex();
%}

%union {
  struct {
    int value, total, optimal;
  } attr;
  int value;
}

%token <value> NUM
%token EOL
%token AND OR NOT
%token LT LE GT GE EQ NE
%token LBRACE RBRACE
%type <attr> expr term
%left OR
%left AND
%left NOT
%left LT LE GT GE EQ NE
%start program

%%
program:
  expr EOL { 
    printf("Output: %s, %d, %d\n", 
      $1.value ? "TRUE" : "FALSE", 
      $1.total,
      $1.total - $1.optimal); 
    yylineno++; 
    yycolno = 0; 
    }
  | program expr EOL { 
    printf("Output: %s, %d, %d\n", 
      $2.value ? "TRUE" : "FALSE", 
      $2.total,
      $2.total - $2.optimal); 
    yylineno++;
    yycolno = 0; 
    }
  ;

expr:
  term { $$ = $1; }
  | expr OR expr { 
    $$.value = $1.value || $3.value; 
    $$.total = $1.total + $3.total;
    if ($1.value)
      $$.optimal = $1.optimal;
    else
      $$.optimal = $1.optimal + $3.optimal;
    }
  | expr AND expr { 
    $$.value = $1.value && $3.value; 
    $$.total = $1.total + $3.total;
    if (!$1.value)
      $$.optimal = $1.optimal;
    else
      $$.optimal = $1.optimal + $3.optimal;
    }
  | LBRACE expr RBRACE {
    $$.value = $2.value; 
    $$.total = $2.total;
    $$.optimal = $2.optimal;
  }
  | NOT expr {
    $$.value = !$2.value; 
    $$.total = $2.total;
    $$.optimal = $2.optimal;
  }
  ;

term:
  NUM {
    $$.value = $1; 
    $$.total = 0;
    $$.optimal = 0;
    }
  | NUM LT NUM { 
    $$.value = $1 < $3; 
    $$.total = 1;
    $$.optimal = 1;
    }
  | NUM LE NUM { 
    $$.value = $1 <= $3; 
    $$.total = 1;
    $$.optimal = 1;
    }
  | NUM GT NUM { 
    $$.value = $1 > $3; 
    $$.total = 1;
    $$.optimal = 1;
    }
  | NUM GE NUM { 
    $$.value = $1 >= $3; 
    $$.total = 1;
    $$.optimal = 1;
    }
  | NUM EQ NUM { 
    $$.value = $1 == $3; 
    $$.total = 1;
    $$.optimal = 1;
    }
  | NUM NE NUM { 
    $$.value = $1 != $3; 
    $$.total = 1;
    $$.optimal = 1;
    }
  ;

%%
void yyerror(const char *s) {
	extern char *yytext;
  char buf[512];
  for (int i = 0; i < yycolno; i++)
    buf[i] = ' ';
  sprintf(buf + (yycolno >= 1 ? yycolno - 1 : 0), "\x1b[31m^\x1b[0m\n");
  fprintf(stderr, "%s", buf);
	fprintf(stderr, "Error: %s near symbol '%s' on line %d, column %d\n", s, yytext, yylineno, yycolno);
}

int main() {
  yyparse();
  return 0;
}
