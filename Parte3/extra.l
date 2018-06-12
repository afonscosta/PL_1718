%option stack
%option yylineno
%option noyy_top_state
%option nounput
%option noinput
%x state_id state_sn

%{
int termina = 0;
%}

%%
[ \n\t]		;

^%.*		;

<*>#.*		;

^SN\ 					{ printf("%s", yytext); yy_push_state(state_sn); }
<state_sn>\n\t			;
<state_sn>\n			{ yy_pop_state(); }
<state_sn>\n\n 			{ printf("%cXXXXXXX", *yytext); yy_pop_state(); }
<state_sn>[^#\n\t]+		{ printf("%s", yytext); }
<state_sn>\t			;

^[A-Z]+\ 				{ printf("%s", yytext); yy_push_state(state_id); }
<state_id>\n\t			;
<state_id>\n			{ if (termina) printf("XXXXXXX%c", *yytext);
						  else printf("!!!"); 
						  yy_pop_state(); }
<state_id>\n\n			{ printf("XXXXXXX%c", *yytext); 
						  yy_pop_state(); }
<state_id>\n\t#.*		{ printf("XXXXXXX%c", *yytext); 
						  yy_pop_state(); }
<state_id>\n[\t ]{2,}	{ termina = 1; }
<state_id>[^,\n#\t]+ 	{ termina = 0; printf("%s", yytext); }
<state_id>, 			{ printf("%c", *yytext); }
<state_id>\t			;

^[a-zA-Z]+	{ printf("%s\n", yytext); }

<*>.		{ printf("ERRO\n"); }

