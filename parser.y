%{
#include <stdio.h>
#include <string.h>

void yyerror(const char *s);
int yylex();
%}

%union {
  struct {
    int value, total, optimal;
  }attr;
  int value;
}

%token <value> NUMBER
%token AND OR
%token LT LE GT GE EQ NE
%token NOT
%type <attr> expr term
%left OR
%left AND
%left NOT
%left LT LE GT GE EQ NE


%%
program:
  expr { 
    printf("Output: %s, %d, %d\n", 
      $1.value ? "TRUE" : "FALSE", 
      $1.total,
      $1.total - $1.optimal); 
    }
  ;

expr:
  term { $$ = $1; }
  | expr OR expr { 
    // printf("expr -> expr(%d) || expr(%d)\n", $1.value, $3.value);
    $$.value = $1.value || $3.value; 
    $$.total = $1.total + $3.total;
    if ($1.value)
      $$.optimal = $1.optimal;
    else
      $$.optimal = $1.optimal + $3.optimal;
    }
  | expr AND expr { 
    // printf("expr -> expr(%d) && expr(%d)\n", $1.value, $3.value);
    $$.value = $1.value && $3.value; 
    $$.total = $1.total + $3.total;
    if (!$1.value)
      $$.optimal = $1.optimal;
    else
      $$.optimal = $1.optimal + $3.optimal;
    }
  | '(' expr ')' {
    // printf("expr -> (expr(%d))\n", $2.value);
    $$.value = $2.value; 
    $$.total = $2.total;
    $$.optimal = $2.optimal;
  }
  | NOT expr {
    // printf("expr -> !expr(%d)\n", $2.value);
    $$.value = !$2.value; 
    $$.total = $2.total;
    $$.optimal = $2.optimal;
  }
  ;

term:
  NUMBER { 
    // printf("term -> NUMBER(%d)\n", $1);
    $$.value = $1; 
    $$.total = 0;
    $$.optimal = 0;
    }
  | term LT NUMBER { 
    // printf("term -> term(%d) < NUMBER(%d)\n", $1.value, $3);
    $$.value = $1.value < $3; 
    $$.total = $1.total + 1;
    $$.optimal = $1.optimal + 1;
    }
  | term LE NUMBER { 
    // printf("term -> term(%d) <= NUMBER(%d)\n", $1.value, $3);
    $$.value = $1.value <= $3; 
    $$.total = $1.total + 1;
    $$.optimal = $1.optimal + 1;
    }
  | term GT NUMBER { 
    // printf("term -> term(%d) > NUMBER(%d)\n", $1.value, $3);
    $$.value = $1.value > $3; 
    $$.total = $1.total + 1;
    $$.optimal = $1.optimal + 1;
    }
  | term GE NUMBER { 
    // printf("term -> term(%d) >= NUMBER(%d)\n", $1.value, $3);
    $$.value = $1.value >= $3; 
    $$.total = $1.total + 1;
    $$.optimal = $1.optimal + 1;
    }
  | term EQ NUMBER { 
    $$.value = $1.value == $3; 
    $$.total = $1.total + 1;
    $$.optimal = $1.optimal + 1;
    }
  | term NE NUMBER { 
    $$.value = $1.value != $3; 
    $$.total = $1.total + 1;
    $$.optimal = $1.optimal + 1;
    }
  ;

%%
void yyerror(const char *s) {
  fprintf(stderr, "Error: %s\n", s);
}

int main() {
  yyparse();
  return 0;
}