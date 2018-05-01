%option reentrant stack noyywrap
%x lista italico negrito sublinhado riscado titulo
%{
#include <stdlib.h>
#include <string.h>
FILE* out;

%}
%%

^[0-9]\.			{ BEGIN lista; }

<lista>^[\n]			{ BEGIN 0; }

<*>(\*|\_)[^*_]			{printf("\\emph{%s", yytext);
				 yy_push_state(italico, yyscanner);
				 printf("}");}

<*>(\*\*|\_\_)[^*]		{printf("\\textbf{%s", yytext);
				 yy_push_state(negrito, yyscanner);
				 printf("}");}

<italico>(\*|\_)		{yy_pop_state(yyscanner);}

<negrito>(\*\*|\_\_) 

.				;
%%
void beginDocument(){
	printf("\\documentclass[a4paper]{article}\n\n");
	printf("\\usepackage[portuguese]{babel}\n\n");
	printf("\\usepackage[utf8]{inputenc}\n");
	printf("\\usepackage{ulem}\n");
	printf("\\usepackage{blindtext}\n");
	printf("\\usepackage{scrextend}\n");
	printf("\\setkomafont{labelinglabel}{\\ttfamily}\n");
	printf("\\setkomafont{labelingseparator}{\\normalfont}\n\n");
	printf("\\begin{document}\n\n");
}

void endDocument(){
	printf("\\end{document}");
}

int main(int argc, char* argv[]){
	yyscan_t scanner;
	yylex_init(&scanner);
	YY_BUFFER_STATE buffer;
	if (argc == 1){
		out = stdout;
		beginDocument();
		yylex(scanner);
		endDocument();
	}
	else {
		for (int i = 1; i < argc; i++){
			char s[500];
			sprintf(s, "%s.tex", argv[i]);
			out = fopen(s, "w");
			buffer = yy_scan_string(argv[i], scanner);
			beginDocument();
			yylex(scanner);
			endDocument();
			yy_delete_buffer(buffer, scanner);
		}
	}
}
