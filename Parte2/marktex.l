%option reentrant stack noyywrap
%x lista italic bold under sout
%{
#include <stdlib.h>
#include <string.h>
FILE* out;

%}
%%

^[0-9]\.			{ BEGIN lista; }

<lista>^[\n]			{ BEGIN 0; }

^#\ .+\n			{yytext[yyleng - 1] = '\0';
				 printf("\\section{%s}\n", yytext + 2);}


^#{2}\ .+\n			{yytext[yyleng - 1] = '\0';
				 printf("\\subsection{%s}\n", yytext + 3);}


^#{3}\ .+\n			{yytext[yyleng - 1] = '\0';
				 printf("\\subsubsection{%s}\n", yytext + 4);}

<italic>\/			{printf("}");
				 yy_pop_state(yyscanner);}

<bold>\*			{printf("}");
				 yy_pop_state(yyscanner);}

<sout>~				{printf("}");
				 yy_pop_state(yyscanner);}

<under>_			{printf("}");
				 yy_pop_state(yyscanner);}

<*>\/				{printf("\\textit{");
				 yy_push_state(italic, yyscanner);}


<*>\*				{printf("\\textbf{");
				 yy_push_state(bold, yyscanner);}

<*>~				{printf("\\sout{");
				 yy_push_state(sout, yyscanner);}

<*>_				{printf("\\underline{");
				 yy_push_state(under, yyscanner);}

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
