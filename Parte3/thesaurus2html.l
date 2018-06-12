%option stack
%option yylineno
%option noyy_top_state
%option nounput
%option noinput
%x state_id state_sn

%{
#include "y.tab.h"
%}


%%
[ \n\t]		;

^%.*		;

<*>#.*		;

^SN\ 					{ yylval.id = strdup(yytext); yy_push_state(state_sn); return SN; }
<state_sn>\n\t			;
<state_sn>\n			{ yy_pop_state(); }
<state_sn>\n\n 			{ return *yytext; yy_pop_state(); }
<state_sn>[^#\n\t]+		{ yylval.str = strdup(yytext); return STR; }
<state_sn>\t			;

^[A-Z]+\ 				{ yylval.id = strdup(yytext); yy_push_state(state_id); return ID; }
<state_id>\n\t			;
<state_id>\n			{ yy_pop_state(); }
<state_id>\n\n			{ return *yytext; yy_pop_state(); }
<state_id>[^,\n#\t]+ 	{ yylval.str = strdup(yytext); return STR; }
<state_id>, 			{ return *yytext; }
<state_id>\t			;

^[a-zA-Z]+	{ yylval.mt = strdup(yytext); return MT; }

<*>.		{ return ERRO; }
