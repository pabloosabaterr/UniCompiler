#ifndef LEXICO1_H
#define LEXICO1_H

typedef enum {
    // Palabras reservadas
    TOK_VOID,
    TOK_VAR,
    TOK_CONST,
    TOK_READ,
    TOK_PRINT,
    TOK_IF,
    TOK_ELSE,
    TOK_WHILE,
    TOK_FOR,
    TOK_DO,
    TOK_BREAK,
    // Identificadores y literales
    TOK_ID,
    TOK_INT,
    TOK_INTLITERAL,
    TOK_STRINGLITERAL,
    // Delimitadores
    TOK_LPAREN,
    TOK_RPAREN,
    TOK_LBRACKET,
    TOK_RBRACKET,
    TOK_SEMICOLON,
    TOK_COMMA,
    // Operadores de asignación
    TOK_ASSIGNOP,
    TOK_PLUSEQ,
    TOK_MINUSEQ,
    TOK_MULTEQ,
    TOK_DIVEQ,
    TOK_MODEQ,
    // Operadores aritméticos
    TOK_PLUSOP,
    TOK_MINUSOP,
    TOK_MULTOP,
    TOK_DIVOP,
    TOK_MODOP,
    // Operadores logicos y de comparación
    TOK_EQ,
    TOK_NEQ,
    TOK_LT,
    TOK_GT,
    TOK_LTEQ,
    TOK_GTEQ,
    TOK_NOT,
} Token;

#endif /* LEXICO1_H */ 