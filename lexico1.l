%{
#include "lexico1.h"
void error_lexico();
void comienzoComentario();
void finComentario();
// el nivel nunca puede ser negativo, 0 para codigo, 1 || > 1 para comentarios anidados
uint32_t nivelComentario=0;
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
begin                               return TOK_BEGINN;
end                                 return TOK_END;
read                                return TOK_READ;
write                               return TOK_WRITE;
main                                return TOK_MAIN;
print                               return TOK_PRINT;
({letra}|_|$)({letra}|{digito}|_)*  return TOK_ID;
{entero}                            return TOK_INTLITERAL;
"("                                 return TOK_LPAREN;		
")"                                 return TOK_RPAREN;
";"                                 return TOK_SEMICOLON;
","                                 return TOK_COMMA;
":="                                return TOK_ASSIGNOP;
"+"                                 return TOK_PLUSOP;
"-"                                 return TOK_MINUSOP;
"{"                                 return TOK_LBRACKET;
"}"                                 return TOK_RBRACKET;
.                                   error_lexico();
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

void error_lexico()
{
  printf("\nERROR, simbolo no reconocido %s en linea %d\n",yytext, yylineno);
}

void main() {
    Token tok = 0;
    while (tok=yylex())
        printf("%d %s\n", tok, yytext);
    printf("FIN DE ANALISIS LEXICO\n");
}
