%{
#include "lexer.h"
void errorLexico();
void comienzoComentario();
void finComentario();
void manejarString();
// el nivel nunca puede ser negativo, 0 para codigo, 1 || > 1 para comentarios anidados
uint32_t nivelComentario=0;
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
<STRING>[^\n"]*\"                   {manejarString(); return TOK_STRINGLITERAL;}
"\""                                manejarString();
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
* @brief cambie el estado si esta dentro o fuera de un string
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
    while((c = input()) != EOF && strchr(delimitadores, c) == NULL); // Ignorar el resto de la línea
    if(c != EOF) unput(c); // devuelve el delimitador por si hay multiples expresiones en la misma linea
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
