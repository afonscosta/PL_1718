%x lista 

%{

#include <stdlib.h>
#include <string.h>
FILE* out;

int listasEnum[4] = {-1, -1, -1, -1};
char listasItem[4] = {' ', ' ', ' ', ' '};

void beginEnumerate(int l);
void processEnumeratedItem(int l);
void closeEnumerate(int l);
void beginItemize(int l, char c);
void processItemizeItem();
void closeItemize(int l);

%}

%%

[ \t\n]						;
						  
^[0-9]+\..+					{ beginEnumerate(0); 
						  	  processEnumeratedItem(0); 
						  	  BEGIN lista; }

^[+\-*].+					{ beginItemize(0, yytext[0]); 
						  	  processItemizeItem(0); 
						  	  BEGIN lista; }

<lista>^[\n]				{ closeEnumerate(3);
						  	  closeEnumerate(2);
						  	  closeEnumerate(1);
						  	  closeEnumerate(0);
							  closeItemize(3);
                              closeItemize(2);
                              closeItemize(1);
                              closeItemize(0);
						  	  BEGIN 0; }

<lista>^[+\-*].+			{ closeItemize(1);
							  processItemizeItem(0); }

<lista>^\t[+\-*].+			{ closeItemize(2);
							  beginItemize(1, yytext[0]);
							  processItemizeItem(1); }

<lista>^\t\t[+\-*].+		{ closeItemize(3);
						  	  beginItemize(2, yytext[0]);
						      processItemizeItem(2); }

<lista>^\t\t\t[+\-*].+		{ beginItemize(3, yytext[0]); 
							  processItemizeItem(3); }


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

// LISTAS NÃO ORDENADAS
void beginItemize(int l, char c) {
	int i = 0;
	if (listasItem[l] == ' ') {
		listasItem[l] = c;
		printf("\\begin{itemize}\n");
	}
}

void processItemizeItem(int l) {
	while (l-- > 0) yytext++; //Tira os tabs
	yytext++; //Tira o *, + ou -
	printf("\\item %s", yytext); 
}

void closeItemize(int l) {
	if (listasItem[l] != ' ') {
		printf("\\end{itemize}\n"); 
		listasItem[l] = ' ';
	}
}

// LISTAS ORDENADAS
void beginEnumerate(int l) {
	int i = 0;
	if (listasEnum[l] == -1) {
		for (i = 0; yytext[i] != '.' && i < strlen(yytext); i++);
		if (yytext[i] == '.') {
			char num[i+1]; //mais 1 para o \0
			strncpy(num, yytext, i);
			num[i] = '\0'; 
			listasEnum[l] = atoi(num); 
			printf("\\begin{enumerate}\n");
		}
	}
}

void processEnumeratedItem(int l) {
	while ((*yytext) != '.') yytext++; //fica a apontar para o '.'
	printf("\\item %s", yytext + 1); 
	listasEnum[l]++;
}

void closeEnumerate(int l) {
	if (listasEnum[l] != -1) {
		printf("\\end{enumerate}\n"); 
		listasEnum[l] = -1;
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
