%option stack
%x lista italic bold under sout title color notas

%{

#include <stdlib.h>
#include <string.h>

FILE* out;

int listasEnum[4] = {0, 0, 0, 0};
int listasItem[4] = {0, 0, 0, 0};

void beginEnumerate(int l);
void closeEnumerate(int l);
void beginItemize(int l);
void closeItemize(int l);
void createToDoIntense();
void parseLink(char* string);
void parseImage(char* string);
void processCodeBlock();

%}

%%

!\[[^\]]+\]\([^)]+\)	{ parseImage(yytext); }

\[[^\]]+\]\([^)]+\)		{ parseLink(yytext); }

^[\-*_]{3,}				{ printf("\\vspace{10pt}\n\\hrule\n\\vspace{10pt}\n"); }

<*>\\->					{printf("->");}

^.+->					{ yytext[yyleng - 2] = '\0';
			  			  printf("\\textbf{%s} $\\bullet$\\ ", yytext); }


^#{1,3}\ 				{ switch(yyleng) {
			      		      case 2 :
				      		      printf("\\section{");
					  			  break;
				  			  case 3 :
				      			  printf("\\subsection{");
					  			  break;
				  			  default :
					  			  printf("\\subsubsection{"); 
			  			  }
			  			  BEGIN title; }


\$\$					{ yy_push_state(notas); }

<notas>\[				{ printf("\\hlfix{"); }
<notas>\]\(				{ printf("}{"); }
<notas>\)				{ printf("}~"); 
				  		  yy_pop_state(); }

!{1,3}[^!]+!{1,3}		{ createToDoIntense(); }


^[0-9]+\.				{ beginEnumerate(0); 
						  printf("\\item "); 
						  BEGIN lista; }

^[+\-*]\ 				{ beginItemize(0); 
						  printf("\\item "); 
						  BEGIN lista; }


<lista>^[\n]			{ closeEnumerate(3);
						  closeEnumerate(2);
						  closeEnumerate(1);
						  closeEnumerate(0);
						  closeItemize(3);
                          closeItemize(2);
                          closeItemize(1);
                          closeItemize(0);
						  BEGIN 0; }

<lista>^[+\-*]\ 		{ closeItemize(1);
						  closeItemize(2);
						  closeItemize(3);
						  printf("\\item "); }

<lista>^\t[+\-*]\ 		{ closeItemize(2);
						  closeItemize(3);
						  beginItemize(1);
						  printf("\\item "); }

<lista>^\t\t[+\-*]\ 	{ closeItemize(3);
						  beginItemize(2);
						  printf("\\item "); }

<lista>^\t\t\t[+\-*]\ 	{ beginItemize(3); 
						  printf("\\item "); }

<lista>^[0-9]+\.		{ closeEnumerate(1);
						  closeEnumerate(2);
						  closeEnumerate(3);
						  beginEnumerate(0);
						  printf("\\item "); }

<lista>^\t[0-9]+\.		{ closeEnumerate(2);
						  closeEnumerate(3);
						  beginEnumerate(1);
						  printf("\\item "); }

<lista>^\t\t[0-9]+\.	{ closeEnumerate(3);
						  beginEnumerate(2);
						  printf("\\item "); }

<lista>^\t\t\t[0-9]+\.	{ beginEnumerate(3); 
						  printf("\\item "); }


<title>\n				{ printf("}\n");
				 		  BEGIN 0; }

<italic>\/				{ printf("}");
				 		  yy_pop_state(); }

<bold>\*				{ printf("}");
				 		  yy_pop_state();}

<sout>~					{ printf("}");
				 		  yy_pop_state(); }

<under>_				{ printf("}");
				 		  yy_pop_state(); }

<color>;				{ printf("}");
				 		  yy_pop_state(); }

<*>\\[\/*~_`;!\[\]()]			{ printf("%s", yytext + 1); }

<*>\/					{ printf("\\textit{");
				 		  yy_push_state(italic); }

<*>\*					{ printf("\\textbf{");
				 		  yy_push_state(bold); }

<*>~					{ printf("\\sout{");
				 		  yy_push_state(sout); }

<*>_					{ printf("\\underline{");
				 		  yy_push_state(under); }


<*>;[a-zA-Z][a-zA-Z!0-9]+\ 	{ yytext[yyleng - 1] = '\0';
				 			  printf("\\textcolor{%s}{", yytext + 1);
				 			  yy_push_state(color); }

<*>;[a-zA-Z][a-zA-Z!0-9]+;	{ yytext[yyleng - 1] = '\0';
				 			  printf("\\color{%s}", yytext + 1); }


<*>`.+`								{ yytext[yyleng - 1] = '\0';
				 			  		  printf("\\texttt{%s}", yytext + 1); }

^```([a-zA-Z0-9]+)?\n[^`]+\n```\n	{ processCodeBlock(); }
%%

// IMAGENS --------
void parseImage(char* string){
	char legenda[500];
	char imagem[500];
	int i = 0;

	for (i = 2; string[i] != ']'; i++)
		legenda[i - 2] = string[i];

	i += 2;
	for (int j = 0; string[i] != ')'; i++, j++)
		imagem[j] = string[i];

	printf("\\begin{figure}[h]\n");
	printf("\\centering\n");
	printf("\\includegraphics[width=\\linewidth, height=\\textheight,keepaspectratio]{%s}\n",imagem );
	printf("\\caption{%s}\n", legenda);
	printf("\\end{figure}\n");

}
//-----------------


// LINKS ----------
void parseLink(char* string){
	char texto[500];
	char url[500];
	int i = 0;

	for (i = 1; string[i] != ']'; i++ )
		texto[i - 1] = string[i];

	i += 2;
	for (int j = 0; string[i] != ')'; i++, j++)
		url[j] = string[i];

	printf("\\href{%s}{\\textit{%s}}\n", url, texto);
}
//-----------------


// NOTAS ----------
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
//-----------------


// LISTAS NÃO ORDENADAS
void beginItemize(int l) {
	if (listasItem[l] == 0) {
		listasItem[l] = 1;
		printf("\\begin{itemize}\n");
	}
}

void closeItemize(int l) {
	if (listasItem[l] == 1) {
		printf("\\end{itemize}\n"); 
		listasItem[l] = 0;
	}
}
//-----------------


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
//-----------------


// CODE -----------
void processCodeBlock(){
	printf("\\begin{lstlisting}");
	int i = 3;
	if(yytext[3] != '\n'){
		for(i = 3; yytext[i] != '\n'; i++);
		yytext[i] = '\0';
		printf("[language=%s]\n", yytext + 3);
		}
	yytext[yyleng - 5] = '\0';
	printf("%s\n\\end{lstlisting}\n", yytext + 1 + i);
}
//-----------------


// LATEX ----------
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
	printf("\\usepackage{caption}");
	printf("\\usepackage{graphicx}");
	printf("\\usepackage{hyperref}\n");
	printf("\\usepackage{listings}\n");
	printf("\\usepackage{xcolor}\n");
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
//-----------------


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
			fclose(out);
		}
	}
}
