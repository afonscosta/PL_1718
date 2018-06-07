%{
#include <stdio.h>
#include <math.h>
//#include <glib.h>

extern int asprintf(char **strp, const char *fmt, ...);
extern int yylex();
extern char *yytext;
extern int yylineno;
void yyerror(char*);

%}

%token MT STR ID ERRO
%union {
	char* mt;
	char* id;
    char* str;
}

%type <id> ID
%type <mt> MT
%type <str> STR STRS

%%

Cs : Cs C
   | C
   ;

C : Es
  ;

Es : Es E
   | E
   ;

E : MT				{ printf("%s\n", $1); }
  | ID STRS			{ printf("%s %s\n", $1, $2); }
  ;

STRS : STR			{ $$ = $1; }
    | STRS ',' STR	{ sprintf($$, "%s, %s", $1, $3); }
    ;


%%

int main(){
	yyparse();
	return 0;
}

void yyerror(char* erro){
	fprintf(stderr, "%s, %s, %d", erro, yytext, yylineno);
}
