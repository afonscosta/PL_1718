
%option stack
%x lista italic bold under sout title notas

%{

#include <stdlib.h>
#include <string.h>

FILE* out;

int listasEnum[4] = {0, 0, 0, 0};
char listasItem[4] = {' ', ' ', ' ', ' '};

void beginEnumerate(int l);
void processItem();
void closeEnumerate(int l);
void beginItemize(int l, char c);
void processItemizeItem();
void closeItemize(int l);
void createToDoIntense();

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

\$\$			{ yy_push_state(notas); }

<notas>\[		{ printf("\\hlfix{"); }
<notas>\]\(		{ printf("}{"); }
<notas>\)		{ printf("}~"); 
				  yy_pop_state(); }

!{1,3}[^!]+!{1,3}	{ createToDoIntense(); }

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

void createToDoHighlight() {

}

void createToDoIntense() {
	
	int i;
	for(i = 0; yytext[i] == '!' && i < yyleng; i++);
	if (i != yyleng) {
		yytext[yyleng - i] = '\0';
		switch(i) {
			case 1 :
				printf("\\todo[color=green!40]{%s}", yytext + i);
				break;
			case 2 :
				printf("\\todo[color=yellow!50]{%s}", yytext + i);
				break;
			default :
				printf("\\todo[color=red!50]{%s}", yytext + i);
		}
	}
}

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
	printf("\\usepackage{soul}\n");
	printf("\\usepackage[colorlinks]{hyperref}\n");
	printf("\\usepackage[colorinlistoftodos]{todonotes}\n");
	printf("\\setkomafont{labelinglabel}{\\ttfamily}\n");
	printf("\\setkomafont{labelingseparator}{\\normalfont}\n");
	printf("\\newlist{legal}{enumerate}{10}\n");
	printf("\\setlist[legal]{label*=\\arabic*.}\n");
	printf("\\newcommand{\\hlfix}[2]{\\texthl{#1}\\todo{#2}}\n\n");
	printf("\\begin{document}\n\n");
}

void endDocument(){
	printf("\\end{document}\n");
}


int main(int argc, char* argv[]){
	if (argc == 1){
		beginDocument();
		yylex();
		endDocument();
	}
	else {
		for (int i = 1; i < argc; i++){
			char s[500];
			sprintf(s, "%s.tex", argv[i]);
			freopen(s, "w", stdout);
			beginDocument();
			yylex();
			endDocument();
		}
	}
}
