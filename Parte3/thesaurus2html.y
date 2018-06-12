%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <glib.h>
#include <string.h>
#include <fcntl.h> // open function
#include <unistd.h> // close function
#include <assert.h>
#include <math.h>

int asprintf(char **strp, const char *fmt, ...);
extern int yylex();
extern char *yytext;
extern int yylineno;
void yyerror(char*);

void removeSpaces(char *str);
char** str_split(char* a_str, const char a_delim);
static void iterator_dentro(gpointer key, gpointer value, gpointer user_data);
static void iterator_fora(gpointer key, gpointer value, gpointer user_data);
void print_hash(GHashTable* hash);

GHashTable* conceitos;
GHashTable* elems_atual;
GHashTable* descriptions;
GHashTable* inverses;
char *conceito_atual;
char *top;
char *enc;


%}

%token MT STR ID ERRO SN TOP ENC INV DESC EXT LANG BASELANG

%union {
	char* id;
    char* str;
}

%type <id> ID SN IDs
%type <str> STR STRs TXTs TOP ENC MT


%%


Cs : Cs '\n' C  	
   | C				
   ;

C : Es  
  | TOP				{ top = strdup($1); }
  | ENC				{ enc = strdup($1); }
  | INV ID ID		{ g_hash_table_insert(inverses, $2, $3); 
   					  g_hash_table_insert(inverses, $3, $2); }
  | DESC ID STRs	{ g_hash_table_insert(descriptions, $2, $3); }
  | EXT IDs		
  | LANG IDs	
  | BASELANG ID	
  ;

Es : Es E  
   | E 	
   ;

E : MT			{ removeSpaces($1);
  				  conceito_atual = strdup($1); 
  				  g_hash_table_insert(conceitos, conceito_atual, g_hash_table_new(g_str_hash, g_str_equal)); }
  | SN TXTs		{ GHashTable* elems_atual = g_hash_table_lookup(conceitos, conceito_atual);
  				  if (elems_atual != NULL) {
					  if (!g_hash_table_contains(elems_atual, $1)) {
					  	  removeSpaces($1);
						  g_hash_table_insert(elems_atual, $1, $2); 
					  }
					  else {
					      char *strs = g_hash_table_lookup(elems_atual, $1);
						  strs = realloc(strs, sizeof(char)*(strlen(strs)+strlen($2)+2));
						  strcat(strs, ", ");
						  strcat(strs, $2);
					  }
				  }
				}
  | ID STRs		{ GHashTable* elems_atual = g_hash_table_lookup(conceitos, conceito_atual);
  				  if (elems_atual != NULL) {
					  removeSpaces($1);
					  if (!g_hash_table_contains(elems_atual, $1)) {
						  g_hash_table_insert(elems_atual, $1, $2); 
					  }
					  else {
					      char *strs = g_hash_table_lookup(elems_atual, $1);
						  asprintf(&strs, "%s, %s", strs, $2);
						  printf("XXXX %s\n", strs);
						  g_hash_table_insert(elems_atual, $1, strdup(strs)); 
						  free(strs);
					  }
				  }
				}
  ;

IDs : ID		{ asprintf(&$$, "%s", $1); }
    | IDs ID	{ asprintf(&$$, "%s,%s", $1, $2); }	
    ;

STRs : STR			{ asprintf(&$$, "%s", $1); }
     | STRs ',' STR	{ asprintf(&$$, "%s,%s", $1, $3); }
     ;

TXTs : STR		{ asprintf(&$$, "%s", $1); }
     | TXTs STR	{ asprintf(&$$, "%s %s", $1, $2); }
     ;


%%

char** str_split(char* a_str, const char a_delim)
{
    char** result    = 0;
    size_t count     = 0;
    char* tmp        = a_str;
    char* last_comma = 0;
    char delim[2];
    delim[0] = a_delim;
    delim[1] = 0;

    /* Count how many elements will be extracted. */
    while (*tmp)
    {
        if (a_delim == *tmp)
        {
            count++;
            last_comma = tmp;
        }
        tmp++;
    }

    /* Add space for trailing token. */
    count += last_comma < (a_str + strlen(a_str) - 1);

    /* Add space for terminating null string so caller
       knows where the list of returned strings ends. */
    count++;

    result = malloc(sizeof(char*) * count);

    if (result)
    {
        size_t idx  = 0;
        char* token = strtok(a_str, delim);

        while (token)
        {
            assert(idx < count);
            *(result + idx++) = strdup(token);
            token = strtok(0, delim);
        }
        assert(idx == count - 1);
        *(result + idx) = 0;
    }

    return result;
}

static void iterator_dentro(gpointer key, gpointer value, gpointer user_data) {
	printf(user_data, *(gchar*)key, value);
	printf("Key: %s || Value: %s\n", (char*) key, (char*) value);
}

static void iterator_fora(gpointer key, gpointer value, gpointer user_data) {
	//printf(user_data, *(gchar*)key, value);
	printf("\nKey: %s\n", (char*) key);
	g_hash_table_foreach(value, (GHFunc)iterator_dentro, NULL);
}

void print_hash(GHashTable* hash){
	printf("\n==== Começou ====\n");
	g_hash_table_foreach(hash, (GHFunc)iterator_fora, NULL);
	printf("==== Acabou ====\n\n");
}


void removeSpaces(char *str)
{
    // To keep track of non-space character count
    int count = 0;

    // Traverse the given string. If current character
    // is not space, then place it at index 'count++'
    for (int i = 0; str[i]; i++)
        if (str[i] != ' ')
            str[count++] = str[i]; // here count is
                                   // incremented
    str[count] = '\0';
}

int main(){
	conceitos = g_hash_table_new(g_str_hash, g_str_equal);
	elems_atual = g_hash_table_new(g_str_hash, g_str_equal);
	descriptions = g_hash_table_new(g_str_hash, g_str_equal);
	inverses = g_hash_table_new(g_str_hash, g_str_equal);

	yyparse();

	g_hash_table_foreach(conceitos, (GHFunc)iterator_fora, NULL);
	//geração da página html com base na estrutura de dados
    FILE* fp = fopen("html_files/index.html", "w+");

    fprintf(fp, "<!DOCTYPE html>\n<html>\n<head>\n\t<meta charset=\"UTF-8\">\n</head>\n<body>\n");

    GHashTableIter iter;
    gpointer key, value;

    g_hash_table_iter_init (&iter, conceitos);
    while (g_hash_table_iter_next (&iter, &key, &value)){

        //criação da entrada no ficheiro index.html
        fprintf(fp, "<p> <a href=\"%s.html\">%s</a> </p>", (char*) key, (char*) key);

        //criação da string com o nome do ficheiro
        char* file_name = "";
        asprintf(&file_name, "html_files/%s.html", key);
        //abertura do ficheiro do conceito
        FILE* fp_aux = fopen(file_name, "w+");

        //inicialização do ficheiro do conceito
        fprintf(fp_aux, "<!DOCTYPE html>\n<html>\n<head>\n\t<meta charset=\"UTF-8\">\n</head>\n<body>\n");
        fprintf(fp_aux, "<p> <a href=\"index.html\">Index</a> </p>");

        GHashTableIter iter1;
        gpointer key1, value1;
		g_hash_table_iter_init (&iter1, value);

        while (g_hash_table_iter_next (&iter1, &key1, &value1)){

            fprintf(fp_aux, "\t<p>%s: ", (char*) key1);

            char** tokens;
            tokens = str_split(value1, ',');

            if (tokens){
                int i = 0;

				// Se estiver nos conceitos gera o href
                if (g_hash_table_contains(conceitos, tokens[i])){
                    fprintf(fp_aux, "<a href=\"%s.html\">%s</a>", tokens[i], tokens[i]);
                }
				// Gera a palavra normal
                else {
                    fprintf(fp_aux, "%s", tokens[i]);
                }
                free(tokens[i]);
                for (i = 1; tokens[i]; i++){
                    if (g_hash_table_contains(conceitos, tokens[i])){
                        fprintf(fp_aux, ", <a href=\"%s.html\">%s</a>", tokens[i], tokens[i]);
                    }
                    else {
                        fprintf(fp_aux, ", %s", tokens[i]);
                    }
                    free(tokens[i]);
                }
                free(tokens);
            }
            fprintf(fp_aux, "</p>\n");
        }

        //fecho do ficheiro de inicialização
        fprintf(fp_aux, "</body>\n</html>");
        fclose(fp_aux);
    }

    fprintf(fp, "</body>\n</html>");
    fclose(fp);
	return 0;
}

void yyerror(char* erro){
	fprintf(stderr, "%s,%s,%d\n", erro, yytext, yylineno);
}
