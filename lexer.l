%{
#include "lexer.h"
void errorLexico();
void comienzoComentario();
void finComentario();
// el nivel nunca puede ser negativo, 0 para codigo, 1 || > 1 para comentarios anidados
uint32_t nivelComentario=0;
const char *delimitadores = "\n;,})]";
%}
digito              [0-9]
%option yylineno
%option noyywrap
letra               [a-zA-Z]
entero              {digito}+
%x COMENT
%%
[ \n\t]+                            ;
"//"(.*)[\n]                        ;
"/*"                                {comienzoComentario();}
<COMENT>"/*"                        {++nivelComentario;}
<COMENT>"*/"                        {finComentario();}
<COMENT>.                           ;
<COMENT>\n                          ;
"end"                               return TOK_END;
"read"                              return TOK_READ;
"main"                              return TOK_MAIN;
"print"                             return TOK_PRINT;
"if"                                return TOK_IF;
"else"                              return TOK_ELSE;
"while"                             return TOK_WHILE;
"for"                               return TOK_FOR;
"do"                                return TOK_DO;
({letra}|_|$)({letra}|{digito}|_)*  return TOK_ID;
{entero}                            return TOK_INTLITERAL;
"("                                 return TOK_LPAREN;		
")"                                 return TOK_RPAREN;
";"                                 return TOK_SEMICOLON;
","                                 return TOK_COMMA;
"=="                                return TOK_EQ;
"+="                                return TOK_PLUSEQ;
"-="                                return TOK_MINUSEQ;
"*="                                return TOK_MULTEQ;
"/="                                return TOK_DIVEQ;
"%="                                return TOK_MODEQ;
"<="                                return TOK_LTEQ;
">="                                return TOK_GTEQ;
"!="                                return TOK_NEQ;
"!"                                 return TOK_NOT;
"="                                 return TOK_ASSIGNOP;
"+"                                 return TOK_PLUSOP;
"-"                                 return TOK_MINUSOP;
"*"                                 return TOK_MULTOP;
"/"                                 return TOK_DIVOP;
"%"                                 return TOK_MODOP;
"<"                                 return TOK_LT;
">"                                 return TOK_GT;
"{"                                 return TOK_LBRACKET;
"}"                                 return TOK_RBRACKET;
.                                   errorLexico();
%%

/**
* @brief aunmenta el nivel de comentario y cambia al estado COMENT
*/
void comienzoComentario(){
    ++nivelComentario;
    BEGIN(COMENT);
}

/**
* @brief decrementa el nivel de comentario, si llega a 0, vuelve al estado inicial
*/
void finComentario(){
    // Si el nivel de comentario es mayor a 0, se decrementa, si llega a 0, se vuelve al estado inicial.
    nivelComentario > 0 && --nivelComentario;
    if(nivelComentario == 0) 
        BEGIN(INITIAL);
}

void errorLexico(){
    printf("\nERROR LEXICO:, simbolo no reconocido %s en linea %d\n",yytext, yylineno);
    int c;
    while((c = input()) != EOF && strchr(delimitadores, c) == NULL); // Ignorar el resto de la línea
}

int main() {
    Token tok = 0;
    while (tok=yylex())
        printf("%d %s\n", tok, yytext);
    printf("FIN DE ANALISIS LEXICO\n");
    return 0;
}
