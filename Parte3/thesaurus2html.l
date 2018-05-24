%{
#include "y.tab.h"
%}


%%
[ \n\t]			;







[()+\-*/\^?!={}]	{ return *yytext; /* return yytext[0]*/ }

[0-9]+(\.[0-9]+)?	{ yylval.num = atof(yytext) ; return NUM; }

[a-z]			{ yylval.id = *yytext; return ID; }

repeat 			{ return REPEAT; }

.			{ return ERRO; }
