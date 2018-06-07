%option stack
%x state_id COMENTARIO

%{
#include "y.tab.h"

%}


%%
[ \n\t]		;

^%.*		;

<*>#.*		;

^[A-Z]*\ 	{ yylval.id = strdup(yytext); yy_push_state(state_id); return ID; }

<state_id>\n\t	;
<state_id>\n	{ yy_pop_state(); }
<state_id>[^,\n#\t]* { yylval.str = strdup(yytext); return STR; }
<state_id>, 		{ return *yytext; }
<state_id>\t	;

^[a-zA-Z]+	{ yylval.mt = strdup(yytext); return MT; }

<*>.			{ printf("ERRO"); }
