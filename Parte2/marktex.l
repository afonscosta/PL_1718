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
						fprintf(out,"\\section{");
						break;
					case 3 :
						fprintf(out,"\\subsection{");
						break;
					default :
						fprintf(out,"\\subsubsection{");
				 }
				 yy_push_state(title, yyscanner);}

<*>\\[\/*~_]			{fprintf(out,"%s", yytext + 1);}

<title>\n			{fprintf(out,"}\n");
				 yy_pop_state(yyscanner);}

<italic>\/			{fprintf(out,"}");
				 yy_pop_state(yyscanner);}

<bold>\*			{fprintf(out,"}");
				 yy_pop_state(yyscanner);}

<sout>~				{fprintf(out,"}");
				 yy_pop_state(yyscanner);}

<under>_			{fprintf(out,"}");
				 yy_pop_state(yyscanner);}

<*>\/				{fprintf(out,"\\textit{");
				 yy_push_state(italic, yyscanner);}


<*>\*				{fprintf(out,"\\textbf{");
				 yy_push_state(bold, yyscanner);}

<*>~				{fprintf(out,"\\sout{");
				 yy_push_state(sout, yyscanner);}

<*>_				{fprintf(out,"\\underline{");
				 yy_push_state(under, yyscanner);}

.				{ECHO;}
%%
void beginDocument(){
	fprintf(out,"\\documentclass[a4paper]{article}\n\n");
	fprintf(out,"\\usepackage[portuguese]{babel}\n\n");
	fprintf(out,"\\usepackage[utf8]{inputenc}\n");
	fprintf(out,"\\usepackage{ulem}\n");
	fprintf(out,"\\usepackage{blindtext}\n");
	fprintf(out,"\\usepackage{scrextend}\n");
	fprintf(out,"\\setkomafont{labelinglabel}{\\ttfamily}\n");
	fprintf(out,"\\setkomafont{labelingseparator}{\\normalfont}\n\n");
	fprintf(out,"\\begin{document}\n\n");
}

void endDocument(){
	fprintf(out,"\\end{document}\n");
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
			yyset_out(out, scanner);
			buffer = yy_create_buffer(in, YY_BUF_SIZE, scanner);
			yy_switch_to_buffer(buffer, scanner);
			beginDocument();
			yylex(scanner);
			endDocument();
			yy_delete_buffer(buffer, scanner);
		}
	}
}
