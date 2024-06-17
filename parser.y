%{
#include <stdio.h>
#include <string.h>

void yyerror(const char *s);
int yylex();
%}

%union {
  struct {
    int value, total, optimal;
  } attr;
  int value;
}

%token <value> NUMBER
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
    }
  | program expr EOL { 
      printf("Output: %s, %d, %d\n", 
        $2.value ? "TRUE" : "FALSE", 
        $2.total,
        $2.total - $2.optimal); 
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
  NUMBER {
    $$.value = $1; 
    $$.total = 0;
    $$.optimal = 0;
    }
  | NUMBER LT NUMBER { 
    $$.value = $1 < $3; 
    $$.total = 1;
    $$.optimal = 1;
    }
  | NUMBER LE NUMBER { 
    $$.value = $1 <= $3; 
    $$.total = 1;
    $$.optimal = 1;
    }
  | NUMBER GT NUMBER { 
    $$.value = $1 > $3; 
    $$.total = 1;
    $$.optimal = 1;
    }
  | NUMBER GE NUMBER { 
    $$.value = $1 >= $3; 
    $$.total = 1;
    $$.optimal = 1;
    }
  | NUMBER EQ NUMBER { 
    $$.value = $1 == $3; 
    $$.total = 1;
    $$.optimal = 1;
    }
  | NUMBER NE NUMBER { 
    $$.value = $1 != $3; 
    $$.total = 1;
    $$.optimal = 1;
    }
  ;

%%
void yyerror(const char *s) {
	extern int yylineno;
  extern int yycolno;
	extern char *yytext;
	fprintf(stderr, "Error: %s near symbol '%s' on line %d, column %d\n", s, yytext, yylineno, yycolno);
}

int main() {
  yyparse();
  return 0;
}
