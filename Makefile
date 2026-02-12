CC = gcc
FLAGS = -Wall -Wextra -pedantic -Werror

all:
	flex lexer.l && $(CC) $(FLAGS) lex.yy.c -lfl -o lexer && ./lexer < entrada.txt