#ifndef LEXICO1_H
#define LEXICO1_H

typedef enum {
    TOK_BEGINN = 1,
    TOK_END,
    TOK_READ,
    TOK_WRITE,
    TOK_ID,
    TOK_INTLITERAL,
    TOK_LPAREN,
    TOK_RPAREN,
    TOK_SEMICOLON,
    TOK_COMMA,
    TOK_ASSIGNOP,
    TOK_PLUSOP,
    TOK_MINUSOP,
    TOK_MAIN,
    TOK_PRINT,
    TOK_RBRACKET,
    TOK_LBRACKET
} Token;

#endif /* LEXICO1_H */ 