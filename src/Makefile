CC = gcc
LL = lex

all: tempdriver lexer

tempdriver: tempdriver.o lex.yy.o
	$(CC) -o tempdriver tempdriver.o lex.yy.o

tempdriver.o: tempdriver.c
	$(CC) -c tempdriver.c

lex.yy.o: lex.yy.c
	$(CC) -c lex.yy.c

lex.yy.c: lexer.l token.h
	$(LL) lexer.l

lexer: lex.yy.c
	$(CC) -o lexer -ll lex.yy.c

clean:
	$(RM) tempdriver lexer lex.yy.c *.o *~
