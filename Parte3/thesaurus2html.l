%option stack
%option yylineno
%option noyy_top_state
%option nounput
%option noinput
%x context_id context_sn context_inv

%{
#include "y.tab.h"
int termina = 0;
%}


%%


[ \n\t]		;

^%top\ .*		{ yylval.str = strdup(yytext + 5); return TOP; }
^%enc\ .*		{ yylval.str = strdup(yytext + 5); return ENC; }
^%inv(erse)?\ 	{ yylval.str = strdup(yytext + 5); return ENC; }
^%.*		;

<*>#.*		;

^SN\ 					{ termina = 0; yylval.id = strdup(yytext); yy_push_state(state_sn); return SN; }
<state_sn>\n\t			;
<state_sn>\n			{ if (termina) { termina = 0;return *yytext;  }
	        			  yy_pop_state(); }
<state_sn>\n\n			{ termina = 0; yy_pop_state() ;return *yytext;  }
<state_sn>\n\t#.*		{ termina = 0;  yy_pop_state(); return *yytext; }
<state_sn>\n[\t ]{2,}	{ termina = 1; }
<state_sn>[^#\n\t]+		{ termina = 0; yylval.str = strdup(yytext); return STR; }
<state_sn>\t			;

^[A-Z]+\ 				{ termina = 0; yylval.id = strdup(yytext); yy_push_state(state_id); return ID; }
<state_id>\n\t			;
<state_id>\n			{ yy_pop_state(); 
						  if (termina) { 
						      //printf("Enviou \\n\n"); 
							  termina = 0;
							  return *yytext; 
						  }
						}
<state_id>\n\n			{ termina = 0;  yy_pop_state();return *yytext; }
<state_id>\n\t#.*		{ termina = 0;  yy_pop_state();return *yytext; }
<state_id>\n[\t ]{2,}	{ termina = 1; }
<state_id>[^,\n#\t]+ 	{ termina = 0; yylval.str = strdup(yytext); return STR; }
<state_id>, 			{ return *yytext; }
<state_id>\t			;

^[a-zA-Z]+				{ yylval.mt = strdup(yytext); return MT; }

<*>.					{ return ERRO; }
