%option stack
%x ID COMENTARIO

%{
#include "y.tab.h"
%}


%%
[ \n\t]		;

<*>#		{ yy_push_state(COMENTARIO); }

<COMENTARIO>.*$	{ yy_pop_state(); }

^[A-Z]*\ 	{ yylval.id = *yytext; yy_push_state(ID); return ID; }

<ID>[^,\n]* { yylval.str = *yytext; return STR; }
<ID>, 		{ return *yytext; }
<ID>\n		{ yy_pop_state(); }

^[a-zA-Z]+	{ yylval.mt = *yytext; return MT; }

.			{ return ERRO; }
