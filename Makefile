CC = gcc
FLAGS = -Wall -Wextra -pedantic -Werror -I src

all:
	mkdir -p build/ && \
	flex -o build/lexer.c src/lexer/lexer.l && \
	$(CC) $(FLAGS) build/lexer.c -lfl -o build/lexer && \
	./build/lexer < entrada.txt
