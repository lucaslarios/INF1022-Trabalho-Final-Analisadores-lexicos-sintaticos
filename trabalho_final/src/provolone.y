%{
      #include <stdlib.h>
      #include <stdio.h>
      #include <string.h>

  
	int yylex();
  FILE* yyin;
  FILE* yyout;
	void yyerror(const char *s){
		fprintf(stderr, "%s\n", s);
	};

 
%}

%union
 {
   char *str;
   int  number;
};
%type  <str> program varlist cmd cmds;
%token <str> PROGRAM;
%token <str> ENTRADA;
%token <str> SAIDA;
%token <str> FIM;
%token <str> ID;
%token <str> ASSIGN;
%token <str> ABREP;
%token <str> FECHAP;
%token <str> INC;
%token <str> ZERA;
%token <str> ENQUANTO;
%token <str> FACA;
%token <str> SE;
%token <str> ENTAO;
%token <str> SENAO;
%start program;
%%
program : PROGRAM ENTRADA varlist SAIDA varlist cmds FIM {
                                                          rewind(yyout);
											                                    fprintf(yyout,"int main(void){\n %s \n %s \n %s \n return 0;\n}",$3,$5,$6);
                                                          printf("int main(void){\n %s \n %s \n %s \n return 0;\n}",$3,$5,$6);
                                                          fclose(yyout);
                                                          exit(1);
											                                   };

varlist : varlist ID                                     {
                                                            char* entrada= (char*) malloc(strlen($1) + strlen($2) + 7);
      
                                                            strcpy(entrada, $1);
                                                            strcat(entrada,"int ");
                                                            strcat(entrada,$2);
                                                            strcat(entrada,"; ");                                                  
                                                            $$ = entrada;
                                                         };

       | ID                                              {
                                                            char* entrada = (char*)malloc(strlen($1) + 8);
                                                            strcpy(entrada,"int ");
                                                            strcat(entrada, $1);
                                                            strcat(entrada,"; ");
                                                            $$ = entrada;
                                                         };


cmds   :  cmd cmds                                        {
                                                            char* commands = (char*) malloc(strlen($1)+strlen($2)+1);   
                                                            strcpy(commands,$1);
                                                            strcat(commands,$2);
                                                            $$ = commands;  
                                                          }
          
       |cmd                                              {
                                                          $$=$1;
                                                         };
              
                                                         

        

cmd    : ID ASSIGN ID                                   {
                                                          char* assign = (char*) malloc(strlen($1) + strlen($2) + 8);
                                                          strcpy(assign,$1);
                                                          strcat(assign," = ");
                                                          strcat(assign,$3);
                                                          strcat(assign,";\n ");
                                                          $$ = assign;
                                                        };
       
       | INC ABREP ID FECHAP                            {
                                                          char* inc = malloc(strlen($3) + 4);
                                                          strcpy(inc,$3);
                                                          strcat(inc,"++;\n");
                                                          $$ = inc;
                                                        }
       | ZERA ABREP ID FECHAP                           {
                                                          char* zera = malloc(strlen($3) + 8);
                                                          strcpy(zera,$3);
                                                          strcat(zera," = 0;\n ");
                                                          $$ = zera;
                                                        }
       
       | ENQUANTO ID FACA cmds FIM                      {
                                                          char* while_cmd = malloc(strlen($2) + strlen($4) + strlen($2)  + 18);
                                                          strcpy(while_cmd,"while(");
                                                          strcat(while_cmd,$2);
                                                          strcat(while_cmd,"){\n ");                                             
                                                          strcat(while_cmd,$4);
                                                          strcat(while_cmd,"\n");
                                                          strcat(while_cmd,$2);
                                                          strcat(while_cmd,"--;\n}\n");
                                                          $$ = while_cmd;
                                                        }     
      | SE ID ENTAO cmds FIM                               {
                                                          char* if_cmd = malloc(strlen($2)+strlen($4)+12);
                                                          strcpy(if_cmd,"if(");
                                                          strcat(if_cmd,$2);
                                                          strcat(if_cmd,"){\n  ");
                                                          strcat(if_cmd,$4);
                                                          strcat(if_cmd,"\n}\n");
                                                          $$ = if_cmd;
                                                        }  

      | SE ID ENTAO cmds SENAO cmds FIM                  {
                                                          char* if_else_cmd = malloc(strlen($2)+strlen($4)+strlen($5)+25);
                                                          strcpy(if_else_cmd,"if(");
                                                          strcat(if_else_cmd,$2);
                                                          strcat(if_else_cmd,"){\n  ");
                                                          strcat(if_else_cmd,$4);
                                                          strcat(if_else_cmd,"\n}\nelse{\n ");
                                                          strcat(if_else_cmd,$6);
                                                          strcat(if_else_cmd,"\n}\n");  
                                                          $$ = if_else_cmd;
                                                        }              
       
%%

int main(int argc, char *argv[]){
    
    //Ler arquivo provolone
    yyin = fopen(argv[1],"r");
    if(yyin==NULL){
      printf("ERROR: Insira um arquivo provolone como parâmetro.");
      exit(1);
    }

    
    //Escreve arquivo C
    char* arq_nome = (char*) malloc(strlen(argv[0]) + 3); 
    strcpy(arq_nome,argv[0]);
    strcat(arq_nome,".c");
    yyout = fopen(arq_nome,"w");

    //parse
    yyparse();
    fclose(yyin);
    return(0);
}