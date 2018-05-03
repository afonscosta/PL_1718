%option reentrant stack
%x lista italic bold under sout title

%{

#include <stdlib.h>
#include <string.h>

FILE* out;
char buffer[1000];

char* replace(char* string, char* token);
char *substring(char *string, int position, int length);

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
^.+->				{yytext[yyleng - 2] = '\0';
				printf("\\textbf{%s} $\\bullet$\\ ", yytext);
				}

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

<*>\\[\/*~_]			{printf("%s", yytext + 1);}

<title>\n			{printf("}\n");
				 yy_pop_state(yyscanner);}

<italic>\/			{printf("}");
				 yy_pop_state(yyscanner);}

<bold>\*			{printf("}");
				 yy_pop_state(yyscanner);}
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

<sout>~				{printf("}");
				 yy_pop_state(yyscanner);}

<under>_			{printf("}");
				 yy_pop_state(yyscanner);}

<*>\/				{printf("\\textit{");
				 yy_push_state(italic, yyscanner);}

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
<*>\*				{printf("\\textbf{");
				 yy_push_state(bold, yyscanner);}

<*>~				{printf("\\sout{");
				 yy_push_state(sout, yyscanner);}

<*>_				{printf("\\underline{");
				 yy_push_state(under, yyscanner);}

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
	printf("\\end{document}\n");
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
