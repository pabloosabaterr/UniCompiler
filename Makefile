CC = gcc
FLAGS = -Wall -Wextra -pedantic -Werror

all:
	flex lexer.l && $(CC) $(FLAGS) lex.yy.c -lfl -o lexer.o && ./lexer.o < entrada.txt