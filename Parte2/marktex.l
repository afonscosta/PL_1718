%x lista 
%{
#include <stdlib.h>
#include <string.h>
FILE* out;

%}
%%

^[0-9]\.			{ BEGIN lista; }

<lista>^[\n]			{ BEGIN 0; }






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
			yyin = fopen(argv[i], "r");
			beginDocument();
			yylex();
			endDocument();
			fclose(out);
		}
	}
}
