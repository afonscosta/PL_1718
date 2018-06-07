%{
#include <stdio.h>
#include <math.h>
//#include <glib.h>

extern int yylex();
extern char *yytext;
extern int yylineno;
void yyerror(char*);

%}

%token MT STR ID ERRO NT RT BT SN USE UF TT
%union {
	char* mt;
	char* id;
    char* str;
}

%type <id> ID NT RT BT SN USE UF TT
%type <mt> MT
%type <str> STR STRs

%%

Cs : Cs C
   | C
   ;

C : Es
  ;

Es : Es E
   | E
   ;

E : MT			{ printf("%s\n", $1); }
  | ID STRs		{ printf("%s %s\n", $1, $2); }
  | NT STRs		{ printf("%s %s\n", $1, $2); }
  | BT STR		{ printf("%s %s\n", $1, $2); }
  | SN STR		{ printf("%s %s\n", $1, $2); }
  | USE STR		{ printf("%s %s\n", $1, $2); }
  | UF STR		{ printf("%s %s\n", $1, $2); }
  | TT STR		{ printf("%s %s\n", $1, $2); }
  ;

STRs : STR			{ $$ = $1; }
    | STRs ',' STR	{ asprintf(&$$, "%s, %s", $1, $3); }
    ;


%%

int main(){
	yyparse();
	return 0;
}

void yyerror(char* erro){
	fprintf(stderr, "%s, %s, %d", erro, yytext, yylineno);
}
