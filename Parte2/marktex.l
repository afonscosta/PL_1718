
%option stack
%x lista italic bold under sout title

%{

#include <stdlib.h>
#include <string.h>

FILE* out;
char buffer[1000];

char* replace(char* string, char* token);
char *substring(char *string, int position, int length);

int listasEnum[4] = {0, 0, 0, 0};
char listasItem[4] = {' ', ' ', ' ', ' '};

void beginEnumerate(int l);
void processItem();
void closeEnumerate(int l);
void beginItemize(int l, char c);
void processItemizeItem();
void closeItemize(int l);

%}

%%
^.+->		{ yytext[yyleng - 2] = '\0';
			  printf("\\textbf{%s} $\\bullet$\\ ", yytext); }


^#{1,3}\ 	{ switch(yyleng) {
			      case 2 :
				      printf("\\section{");
					  break;
				  case 3 :
				      printf("\\subsection{");
					  break;
				  default :
					  printf("\\subsubsection{"); 
			  }
			  yy_push_state(title); }

^[0-9]+\.					{ beginEnumerate(0); 
						  	  processItem(0); 
						  	  BEGIN lista; }

^[+\-*]\ 					{ beginItemize(0, yytext[0]); 
						  	  processItem(0); 
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

<lista>^[+\-*]\ 			{ closeItemize(1);
							  processItem(0); }

<lista>^\t[+\-*]\ 			{ closeItemize(2);
							  beginItemize(1, yytext[0]);
							  processItem(1); }

<lista>^\t\t[+\-*]\ 		{ closeItemize(3);
						  	  beginItemize(2, yytext[0]);
						      processItem(2); }

<lista>^\t\t\t[+\-*]\ 		{ beginItemize(3, yytext[0]); 
							  processItem(3); }

<lista>^[0-9]+\.			{ closeEnumerate(1);
						  	  beginEnumerate(0);
						  	  processItem(0); }

<lista>^\t[0-9]+\.			{ closeEnumerate(2);
							  beginEnumerate(1);
							  processItem(1); }

<lista>^\t\t[0-9]+\.		{ closeEnumerate(3);
						  	  beginEnumerate(2);
						      processItem(2); }

<lista>^\t\t\t[0-9]+\.		{ beginEnumerate(3); 
							  processItem(3); }


<title>\n		{ printf("}\n");
				  yy_pop_state(); }

<italic>\/		{ printf("}");
				  yy_pop_state(); }

<bold>\*		{ printf("}");
				  yy_pop_state(); }

<sout>~			{ printf("}");
				  yy_pop_state(); }

<under>_		{ printf("}");
				  yy_pop_state(); }


<*>\\[\/*~_]	{ printf("%s", yytext + 1); }

<*>\/			{ printf("\\textit{");
				  yy_push_state(italic); }

<*>\*			{ printf("\\textbf{");
				  yy_push_state(bold); }

<*>~			{ printf("\\sout{");
				  yy_push_state(sout); }

<*>_			{ printf("\\underline{");
				  yy_push_state(under); }


%%

// LISTAS NÃO ORDENADAS
void beginItemize(int l, char c) {
	int i = 0;
	if (listasItem[l] == ' ') {
		listasItem[l] = c;
		printf("\\begin{itemize}\n");
	}
}

void processItem() {
	printf("\\item "); 
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
	if (listasEnum[l] == 0) {
		listasEnum[l] = 1;
		printf("\\begin{legal}\n");
	}
}

void closeEnumerate(int l) {
	if (listasEnum[l] == 1) {
		printf("\\end{legal}\n"); 
		listasEnum[l] = 0;
	}
}

void beginDocument(){
	printf("\\documentclass[a4paper]{article}\n\n");
	printf("\\usepackage[portuguese]{babel}\n\n");
	printf("\\usepackage[utf8]{inputenc}\n");
	printf("\\usepackage{ulem}\n");
	printf("\\usepackage{blindtext}\n");
	printf("\\usepackage{scrextend}\n");
	printf("\\usepackage{enumitem}\n");
	printf("\\setkomafont{labelinglabel}{\\ttfamily}\n");
	printf("\\setkomafont{labelingseparator}{\\normalfont}\n");
	printf("\\newlist{legal}{enumerate}{10}\n");
	printf("\\setlist[legal]{label*=\\arabic*.}\n\n");
	printf("\\begin{document}\n\n");
}

void endDocument(){
	printf("\\end{document}\n");
}


int main(int argc, char* argv[]){
	FILE *in;
	if (argc == 1){
		beginDocument();
		yylex();
		endDocument();
	}
	else {
		for (int i = 1; i < argc; i++){
			char s[500];
			sprintf(s, "%s", argv[i]);
			in = fopen(s, "r");
			sprintf(s, "%s.tex", argv[i]);
			freopen(s, "w", stdout);
			beginDocument();
			yylex();
			endDocument();
		}
	}
}
