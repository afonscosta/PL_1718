%option stack
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
				 yy_push_state(title);}

<*>\\[\/*~_]			{printf("%s", yytext + 1);}

<title>\n			{printf("}\n");
				 yy_pop_state();}

<italic>\/			{printf("}");
				 yy_pop_state();}

<bold>\*			{printf("}");
				 yy_pop_state();}

<sout>~				{printf("}");
				 yy_pop_state();}

<under>_			{printf("}");
				 yy_pop_state();}

<*>\/				{printf("\\textit{");
				 yy_push_state(italic);}


<*>\*				{printf("\\textbf{");
				 yy_push_state(bold);}

<*>~				{printf("\\sout{");
				 yy_push_state(sout);}

<*>_				{printf("\\underline{");
				 yy_push_state(under);}

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
	printf("\\end{document}\n");
}

int main(int argc, char* argv[]){
	if (argc == 1){
		out = stdout;
		beginDocument();
		yylex();
		endDocument();
	}
	else {
		for (int i = 1; i < argc; i++){
			char s[500];
			sprintf(s, "%s.tex", argv[i]);
			out = fopen(s, "w");
			beginDocument();
			yylex();
			endDocument();
			fclose(out);
		}
	}
}
