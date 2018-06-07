%{
#include <stdio.h>
#include <math.h>
//#include <glib.h>

extern int yylex();
extern char *yytext;
extern int yylineno;
void yyerror(char*);

%}

%token MT STR ID
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

E : MT
  | ID STRS
  | 'NT' NTs
  | BT
  | SN
  | USE
  | UF
  | TT
  ;

NTs : STR
    | STRS ',' STR

BT : 'BT' STR
   ;

SN : 'SN' STR
   ;

USE : 'USE' STR
    ;

UF : 'UF' STR
   ;

TT : 'TT' STR
   ;

STRS : STR
    | STRS ',' STR
    ;


%%

int main(){
	yyparse();
	return 0;
}

void yyerror(char* erro){
	fprintf(stderr, "%s, %s, %d", erro, yytext, yylineno);
}
