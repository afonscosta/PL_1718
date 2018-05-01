%option reentrant stack
%x lista italic bold under sout title
%{
#include <stdlib.h>
#include <string.h>
FILE* out;

%}
%%

^[0-9]\.			{ BEGIN lista; }

<lista>^[\n]			{ BEGIN 0; }

^#{1,3}\ 			{switch(yyleng){
					case 2 :
						printf("\\section{");
						break;
					case 3 :
						printf("\\subsection{");
						break;
					default :
						printf("\\subsubsection{");
				 }
				 yy_push_state(title, yyscanner);}


<title>\n			{printf("}\n");
				 yy_pop_state(yyscanner);}

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
	FILE *in;
	if (argc == 1){
		out = stdout;
		beginDocument();
		yylex(scanner);
		endDocument();
	}
	else {
		for (int i = 1; i < argc; i++){
			char s[500];
			sprintf(s, "%s", argv[i]);
			in = fopen(s, "r");
			sprintf(s, "%s.tex", argv[i]);
			out = fopen(s, "w");
			buffer = yy_create_buffer(in, YY_BUF_SIZE, scanner);
			yy_switch_to_buffer(buffer, scanner);
			beginDocument();
			yylex(scanner);
			endDocument();
			yy_delete_buffer(buffer, scanner);
		}
	}
}
