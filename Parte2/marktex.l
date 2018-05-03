%option reentrant stack
%x lista italic bold under sout title
%{
#include <stdlib.h>
#include <string.h>

FILE* out;
char buffer[1000];

char* replace(char* string, char* token);
char *substring(char *string, int position, int length);

%}

%%

^.+->				{char *aux = strdup(yytext);
				printf("%s\n", replace(aux, "->"));
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

char *substring(char *string, int position, int length) 
{
   char *pointer;
   int c;
 
   pointer = malloc(length+1);
 
   if( pointer == NULL )
       exit(EXIT_FAILURE);
 
   for( c = 0 ; c < length ; c++ ) 
      *(pointer+c) = *((string+position-1)+c);       
 
   *(pointer+c) = '\0';
 
   return pointer;
}

char* replace(char* string, char* token){

	char *f;
	char aux[10000];
	strcpy(aux, string);

	for (int i = 0; i < string[i] != '\0'; i++){
		if (string[i] == token[0] && string[i + 1] == token[1]){
			f = substring(string, 1, i );
			//printf("%s - - %s\n",f, e);
			
			strcpy(aux, "");
			sprintf(aux, "\\textbf{%s}", f);
			//strcat(aux, f);
			free(f);

			strcat(aux, "$\\bullet$\\");
		}
	}
	return strdup(aux);
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
