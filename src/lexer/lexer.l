%{
#include "lexer/lexer.h"

// funciones auxiliares
void errorLexico();
void comienzoComentario();
void finComentario();
void manejarString();
void absorberString();

// el nivel nunca puede ser negativo, 0 para codigo, 1 || > 1 para comentarios anidados
uint32_t nivelComentario=0;

// flag para saber si estamos dentro de un string o no, para manejar los errores de string sin cerrar
uint8_t dentroDeString = 0;

const char *delimitadores = "\n;,})]";

%}
digito              [0-9]
%option yylineno
%option noyywrap
%option yymore
letra               [a-zA-Z]
entero              {digito}+
%x COMENT
%x STRING
%%
[ \n\t]+                            ;
"//"(.*)[\n]                        ;
"/*"                                comienzoComentario();
<COMENT>"/*"                        ++nivelComentario;
<COMENT>"*/"                        finComentario();
<COMENT>.                           ;
<COMENT>\n                          ;
<STRING>\\\"                        absorberString();
<STRING>\"                          {manejarString(); return TOK_STRINGLITERAL;}
<STRING>.                           absorberString();
\"                                  manejarString();
"int"                               return TOK_INT;
"void"                              return TOK_VOID;
"var"                               return TOK_VAR;
"const"                             return TOK_CONST;
"read"                              return TOK_READ;
"print"                             return TOK_PRINT;
"if"                                return TOK_IF;
"else"                              return TOK_ELSE;
"while"                             return TOK_WHILE;
"for"                               return TOK_FOR;
"do"                                return TOK_DO;
"break"                             return TOK_BREAK;
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

void absorberString(){
    yymore();
}

/**
* @brief cambia el flag dentroDeString
*/
void manejarString(){
    dentroDeString = !dentroDeString;
    if(dentroDeString){
        yymore();
        BEGIN(STRING);
    } 
    else BEGIN(INITIAL);
}

/**
* @brief aunmenta el nivel de comentario y cambia al estado COMENT
* los comentarios anidados funcionan por niveles, cada que se encuentra una apertura se sube un nivel y cada que se encuentre un * * cierre se baja un nivel, siendo el nivel 0 fuera de un comentario y >0 dentro de un comentario.
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
    if(nivelComentario > 0) --nivelComentario;
    if(nivelComentario == 0) 
        BEGIN(INITIAL);
}

void errorLexico(){
    printf("\nERROR: error en la linea %d.\n", yylineno);
    int c;
    // panic mode, si encuentra un error, absorbe todo hasta encontrar un delimitador o el final del archivo
    while((c = input()) != EOF && strchr(delimitadores, c) == NULL); // Ignorar el resto de la línea
    if(c != EOF) unput(c); // devuelve el delimitador por si hay varias expresiones en la misma linea
}

int main() {
    Token tok = 0;
    while ((tok=yylex())){
        if(tok == TOK_INTLITERAL && atoll(yytext) > 2e31){
            printf("\nERROR: entero excede el tamaño maximos de 2e31 en la linea %d\n", yylineno);
        }
        printf("%d %s\n", tok, yytext);
    }
    if(nivelComentario > 0){
        printf("\nERROR: comentario sin cerrar al final del archivo.\n");
    }else if(dentroDeString){
        printf("\nERROR: string sin cerrar al final del archivo.\n");
    }else{
        printf("FIN DE ANALISIS LEXICO\n");
    }
    return 0;
}
