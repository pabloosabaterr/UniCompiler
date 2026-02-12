# proyecto de un compilador (mini c)

esto es un compilador hecho para la parte practica de la asignatura de compiladores de la UMU (universidad de Murcia).

El lexer esta hecho con flex.

---

para ejecutarlo:
```bash
flex lexer.l
gcc lex.yy.c lexer.h -lfl -o lexer.o
./lexer.o < entrada.txt
```