%option stack
%option yylineno
%option noyy_top_state
%option nounput
%option noinput
%x state_id state_sn state_inv state_desc state_desc_id state_ext state_lang state_baselang state_top state_enc
 
%{
#include "y.tab.h"
int termina = 0;
int inv = 0;
%}


%%


[ \n\t]		;

^%top\ 					{ yy_push_state(state_top); return TOP; }
<state_top>[\t\ ]		;
<state_top>\n 			{ yy_pop_state(); return *yytext; }
<state_top>[^\n \t#]+  	{ yylval.id = strdup(yytext); return ID; }

^%enc\ 					{ yy_push_state(state_enc); return ENC; }
<state_enc>[\t\ ]		;
<state_enc>\n 			{ yy_pop_state(); return *yytext; }
<state_enc>[^\n \t#]+  	{ yylval.id = strdup(yytext); return ID; }


^%inv(erse)?\ 			{ yy_push_state(state_inv); return INV; }
<state_inv>[\t\ ]		;
<state_inv>\n 			{ yy_pop_state(); return *yytext; }
<state_inv>[^\n \t#]+  	{ yylval.id = strdup(yytext); return ID; }

^%desc(ription)?\ 			{ yy_push_state(state_desc_id); return DESC; }
<state_desc_id>[^\n \t#]+	{ yylval.id = strdup(yytext); 
							  yy_pop_state();
							  yy_push_state(state_desc); 
							  return ID; }
<state_desc>[\t\ ]		;
<state_desc>\n 			{ yy_pop_state(); return *yytext; }
<state_desc>[^\n\t#]+   { yylval.str = strdup(yytext); return STR; }

^%ext(ernals)?\ 		{ yy_push_state(state_ext); return EXT; }
<state_ext>[\t\ ]		;
<state_ext>\n 			{ yy_pop_state(); return *yytext; }
<state_ext>[^\n \t#]+  	{ yylval.id = strdup(yytext); return ID; }

^%lang(uage)?\ 			{ yy_push_state(state_lang); return LANG; }
<state_lang>[\t\ ]		;
<state_lang>\n 			{ yy_pop_state(); return *yytext; }
<state_lang>[^\n \t#]+  { yylval.id = strdup(yytext); return ID; }

^%baselang\ 				{ yy_push_state(state_baselang); return BASELANG; }
<state_baselang>[\t\ ]		;
<state_baselang>\n 			{ yy_pop_state(); return *yytext; }
<state_baselang>[^\n \t#]+ 	{ yylval.id = strdup(yytext); return ID; }

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

^[A-Z_0-9]+\ 				{ termina = 0; yylval.id = strdup(yytext); yy_push_state(state_id); return ID; }
<state_id>\n\t			;
<state_id>\n			{ yy_pop_state(); 
						  if (termina) { 
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

^[a-z_A-Z]+				{ yylval.str = strdup(yytext); return MT; }

<*>.					{ return ERRO; }
