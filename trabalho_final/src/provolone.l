%option yywrap
    #include <stdio.h>
    #include <string.h>
    #include "provolone.tab.h"
%%
FIM     	return(FIM);
Program  	return(PROGRAM);
INC         return (INC);
ZERA        return(ZERA);
ENTRADA     return(ENTRADA);
SAIDA       return(SAIDA);
ENQUANTO    return (ENQUANTO);
FACA        return(FACA);
SE          return(SE);
ENTAO       return(ENTAO);
SENAO       return(SENAO);
[a-zA-Z/_]+   {printf("lido %s",yytext); yylval.str=strdup(yytext); return ID;}       
"="         return(ASSIGN);
"("         return (ABREP);
")"         return (FECHAP); 
.           
%%

