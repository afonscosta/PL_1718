%option stack
%option yylineno
%option noyy_top_state
%option nounput
%option noinput
%x context_id context_sn

%{
#include "y.tab.h"
%}


%%
[ \n\t]		;

^%.*		;

<*>#.*		;

^SN\ 					{ yylval.id = strdup(yytext); yy_push_state(context_sn); return SN; }
<context_sn>\n\t			;
<context_sn>\n			{ yy_pop_state(); }
<context_sn>\n\n 			{ return *yytext; yy_pop_state(); }
<context_sn>[^#\n\t]+		{ yylval.str = strdup(yytext); return STR; }
<context_sn>\t			;

^[A-Z0-9]+[\t ]+				{ yylval.id = strdup(yytext); yy_push_state(context_id); return ID; }
<context_id>\n\t			;
<context_id>\n			{ yy_pop_state(); }
<context_id>\n\n			{ return *yytext; yy_pop_state(); }
<context_id>[^,\n#\t]+ 	{ yylval.str = strdup(yytext); return STR; }
<context_id>, 			{ return *yytext; }
<context_id>\t			;

^[a-z_A-Z]+	{ yylval.mt = strdup(yytext); return MT; }

<*>.		{ return ERRO; }
