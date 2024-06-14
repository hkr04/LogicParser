.PHONY: all clean

all: logic_parser

logic_parser: parser.tab.c parser.tab.h lex.yy.c
	gcc -std=c11 parser.tab.c lex.yy.c -o logic_parser

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: lexer.l
	flex lexer.l

clean:
	rm -f logic_parser \
	lex.yy.c parser.tab.c parser.tab.h
