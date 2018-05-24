%{
#include <stdio.h>
#include <math.h>

extern int yylex();
extern char *yytext;
extern int yylineno;
void yyerror(char*);

double tab[26] = { 0.0 };
int contaCiclos = 0;
%}

%token NUM ID ERRO FUNC SIN COS Repeat
%union {
	double num;
	char id;
}

%type <id> ID
%type <num> NUM Fator Termo Exp
%type <f> FUNC SIN COS

%%
Maq: { printf("pushn 26\n");
       printf("start\n"); }
     Calc
     { printf("fim: stop\n"); }

Calc : Comando
     | Calc Comando '\n'
     ;

Comando : Escrita
	| Leitura
	| Atrib
	| Repeat
        ;

Repeat :  Repeat '(' Exp ')'
         { contaCiclos++;
           printf("\tpushi %d\n", (int)$3);
           printf("\tstoreg %d\n", 26 - contaCiclos);
           printf("\tciclo%d:\n", contaCiclos); }
	  '{' Calc '}'
	 { printf("\tpushg %d\n", 26 - contaCiclos);
	   printf("\tpushi 1");
	   printf("\tsub\n");
           printf("\tstoreg %d\n", 26 - contaCiclos);
           printf("\tpushg %d\n", contaCiclos);
	   printf("\tfciclo%d", contaCiclos);
	   printf("\tjump ciclo%d\n", contaCiclos);
	   printf("\tfciclo%d:\n", contaCiclos);
	 }
       ;

Escrita: '!' Exp		{ printf("\twritef\n"); }
       ;

Leitura : '?' ID		{ printf("\tread\n");
				  printf("\tatof\n");
				  printf("\tstoreg %d\n", $2 - 'a');
				}
	;

Atrib : ID '=' Exp		{ tab[$1 - 'a'] = $3;
     				  printf("\tstoreg %d\n", $1 - 'a'); }
      ;

Exp : Termo			{ $$ = $1; }
    | Exp '+' Termo		{ $$ = $1 + $3; printf("\tfadd\n"); }
    | Exp '-' Termo		{ $$ = $1 - $3; printf("\tfsub\n"); }
    ;

Termo : Fator			{ $$ = $1; }
      | Termo '*' Fator		{ $$ = $1 * $3; printf("\tmul\n" ); }
      | Termo '/' Fator		{ if($3){
					$$ = $1 / $3;
					printf("\tfdiv\n");
				  }else{
					printf("\terr \"Divisão por 0...\"\n");
					printf("\tjump fim\n");
				   }
				}
      ;


Fator : '(' Exp ')'		{ $$ = $2; }
    | NUM			{ $$ = $1; printf("\tpushf %.2lf\n", $1); }
    | ID			{ $$ = tab[$1 - 'a']; printf("\tpushg %d\n", $1 - 'a'); }
    | Fator '^' Fator		{ $$ = pow($1, $3); }
    | SIN '(' Exp ')'		{ $$ = (*$1)($3); printf("\tfsin\n"); }
    | COS '(' Exp ')'		{ $$ = (*$1)($3); printf("\tfcos\n"); }
    | FUNC '(' Exp ')'		{ $$ = (*1)($3); }
    ;
%%

int main(){
	yyparse();
	return 0;
}

void yyerror(char* erro){
	fprintf(stderr, "%s, %s, %d", erro, yytext, yylineno);
}
