%x lista 

%{

#include <stdlib.h>
#include <string.h>
FILE* out;

int listas[4] = {-1, -1, -1, -1};

void beginEnumerate(int l);
void processEnumeratedItem(int l);
void closeEnumerate(int l);

%}

%%

[ \t\n]						;
						  
^[0-9]+\..+					{ beginEnumerate(0); 
						  	  processEnumeratedItem(0); 
						  	  BEGIN lista; }

<lista>^[\n]				{ closeEnumerate(3);
						  	  closeEnumerate(2);
						  	  closeEnumerate(1);
						  	  closeEnumerate(0);
						  	  BEGIN 0; }
<lista>^[0-9]+\..+			{ closeEnumerate(1);
						  	  beginEnumerate(0);
						  	  processEnumeratedItem(0); }

<lista>^\t[0-9]+\..+		{ closeEnumerate(2);
							  beginEnumerate(1);
							  processEnumeratedItem(1); }

<lista>^\t\t[0-9]+\..+		{ closeEnumerate(3);
						  	  beginEnumerate(2);
						      processEnumeratedItem(2); }

<lista>^\t\t\t[0-9]+\..+	{ beginEnumerate(3); 
							  processEnumeratedItem(3); }

.							;

%%

void beginEnumerate(int l) {
	int i = 0;
	if (listas[l] == -1) {
		for (i = 0; yytext[i] != '.' && i < strlen(yytext); i++);
		if (yytext[i] == '.') {
			char num[i+1]; //mais 1 para o \0
			strncpy(num, yytext, i);
			num[i] = '\0'; 
			listas[l] = atoi(num); 
			printf("\\begin{enumerate}\n");
		}
	}
}

void processEnumeratedItem(int l) {
	while ((*yytext) != '.') yytext++; //fica a apontar para o '.'
	printf("\\item %s", yytext + 1); 
	listas[l]++;
}

void closeEnumerate(int l) {
	if (listas[l] != -1) {
		printf("\\end{enumerate}\n"); 
		listas[l] = -1;
	}
}

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
