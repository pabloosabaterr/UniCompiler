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
begin                               return BEGINN;
end                                 return END;
read                                return READ;
write                               return WRITE;
main                                return MAIN;
print                               return PRINT;
({letra}|_|$)({letra}|{digito}|_)*  return ID;
{entero}                            return INTLITERAL;
"("                                 return LPAREN;		
")"                                 return RPAREN;
";"                                 return SEMICOLON;
","                                 return COMMA;
":="                                return ASSIGNOP;
"+"                                 return PLUSOP;
"-"                                 return MINUSOP;
"{"                                 return LBRACKET;
"}"                                 return RBRACKET;
.                                   error_lexico();
%%

void comienzoComentario(){
    ++nivelComentario;
    BEGIN(COMENT);
}

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
    int i;
    while (i=yylex())
        printf("%d %s\n",i,yytext);
    printf("FIN DE ANALISIS LEXICO\n");
}
