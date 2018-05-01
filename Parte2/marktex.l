%x dic 
%{
#include <stdlib.h>
#include <string.h>

FILE* out;
char buffer[1000];

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

void replace(char* string, char* token){

	char *f, *e;
	int length = strlen(string);

	for (int i = 0; i < string[i] != '\0'; i++){
		if (string[i] == token[0] && string[i + 1] == token[1]){
			f = substring(string, 1, i );
			e = substring(string, i + 3, length - i -2);
			//printf("%s - - %s\n",f, e);
			
			strcpy(string, "");
			sprintf(string, "\\textbf{%s}", f);
			//strcat(string, f);
			free(f);

			strcat(string, " $\\bullet$\\ ");
			strcat(string, e);
			//printf("TESTE - %s\n", string);
			free(e);
		}
	}
}

%}

%%

^.+->.+									{
									  char *aux = strdup(yytext);
									  //printf("%s\n", aux);
									  replace(aux, "->");
									  printf("%s \n", aux);
									}

.+									;

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
