%option stack
%x state_id state_tt state_bt state_nt state_rt state_sn state_uf state_use 

%{
#include "y.tab.h"
%}


%%
[ \n\t]		;

^%.*		;

<*>#.*		;

^NT\ 					{ yylval.id = strdup(yytext); yy_push_state(state_nt); return NT; }
<state_nt>\n\t			;
<state_nt>\n			{ yy_pop_state(); }
<state_nt>[^,\n#\t]* 	{ yylval.str = strdup(yytext); return STR; }
<state_nt>, 			{ return *yytext; }
<state_nt>\t			;

^BT\ 					{ yylval.id = strdup(yytext); yy_push_state(state_bt); return BT; }
<state_bt>\n\t			;
<state_bt>\n			{ yy_pop_state(); }
<state_bt>[^,\n#\t]* 	{ yylval.str = strdup(yytext); return STR; }
<state_bt>, 			{ return *yytext; }
<state_bt>\t			;

^RT\ 					{ yylval.id = strdup(yytext); yy_push_state(state_rt); return RT; }
<state_rt>\n\t			;
<state_rt>\n			{ yy_pop_state(); }
<state_rt>[^,\n#\t]* 	{ yylval.str = strdup(yytext); return STR; }
<state_rt>, 			{ return *yytext; }
<state_rt>\t			;

^SN\ 					{ yylval.id = strdup(yytext); yy_push_state(state_sn); return SN; }
<state_sn>\n\t			;
<state_sn>\n			{ yy_pop_state(); }
<state_sn>[^,\n#\t]* 	{ yylval.str = strdup(yytext); return STR; }
<state_sn>, 			{ return *yytext; }
<state_sn>\t			;

^USE\ 					{ yylval.id = strdup(yytext); yy_push_state(state_use); return USE; }
<state_use>\n\t			;
<state_use>\n			{ yy_pop_state(); }
<state_use>[^,\n#\t]* 	{ yylval.str = strdup(yytext); return STR; }
<state_use>, 			{ return *yytext; }
<state_use>\t			;

^UF\ 					{ yylval.id = strdup(yytext); yy_push_state(state_uf); return UF; }
<state_uf>\n\t			;
<state_uf>\n			{ yy_pop_state(); }
<state_uf>[^,\n#\t]* 	{ yylval.str = strdup(yytext); return STR; }
<state_uf>, 			{ return *yytext; }
<state_uf>\t			;

^TT\ 					{ yylval.id = strdup(yytext); yy_push_state(state_tt); return TT; }
<state_tt>\n\t			;
<state_tt>\n			{ yy_pop_state(); }
<state_tt>[^,\n#\t]* 	{ yylval.str = strdup(yytext); return STR; }
<state_tt>, 			{ return *yytext; }
<state_tt>\t			;

^[A-Z]*\ 				{ yylval.id = strdup(yytext); yy_push_state(state_id); return ID; }
<state_id>\n\t			;
<state_id>\n			{ yy_pop_state(); }
<state_id>[^,\n#\t]* 	{ yylval.str = strdup(yytext); return STR; }
<state_id>, 			{ return *yytext; }
<state_id>\t			;

^[a-zA-Z]+	{ yylval.mt = strdup(yytext); return MT; }

<*>.			{ printf("ERRO"); }
