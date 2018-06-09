%{
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h> // open function
#include <unistd.h> // close function
#include <assert.h>
#include <math.h>
#include <glib.h>
#include <string.h>

int asprintf(char **strp, const char *fmt, ...);
extern int yylex();
extern char *yytext;
extern int yylineno;
void yyerror(char*);

static void iterator_dentro(gpointer key, gpointer value, gpointer user_data);
static void iterator_fora(gpointer key, gpointer value, gpointer user_data);
void print_hash(GHashTable* hash);
char** str_split(char* a_str, const char a_delim);

GHashTable* conceitos;
GHashTable* elems_atual;
char *conceito_atual;
GArray* strs;

%}

%token MT STR ID ERRO NT RT BT SN USE UF TT

%union {
	char* mt;
	char* id;
    char* str;
}

%type <id> ID NT RT BT SN USE UF TT
%type <mt> MT
%type <str> STR STRs


%%


Cs : Cs C		
   | C		
   ;

C : Es 
  ;

Es : Es E 
   | E 
   ;

E : MT			{ conceito_atual = strdup($1); 
  				  g_hash_table_insert(conceitos, conceito_atual, g_hash_table_new(g_str_hash, g_str_equal)); }
  | ID STRs		{ GHashTable* elems_atual = g_hash_table_lookup(conceitos, conceito_atual);
  				  if (elems_atual != NULL)
					  g_hash_table_insert(elems_atual, $1, $2); }
  | NT STRs		{ GHashTable* elems_atual = g_hash_table_lookup(conceitos, conceito_atual);
  				  if (elems_atual != NULL) {
					  if (!g_hash_table_contains(elems_atual, $1)) {
						  g_hash_table_insert(elems_atual, $1, $2); 
					  }
					  else {
					      char *nts = g_hash_table_lookup(elems_atual, $1);
						  nts = realloc(nts, sizeof(char)*(strlen(nts)+strlen($2)+2));
						  strcat(nts, ", ");
						  strcat(nts, $2);
					  }
				  }
				}
  | BT STRs		{ GHashTable* elems_atual = g_hash_table_lookup(conceitos, conceito_atual);
  				  if (elems_atual != NULL) {
					  if (!g_hash_table_contains(elems_atual, $1)) {
						  g_hash_table_insert(elems_atual, $1, $2); 
					  }
					  else {
					      char *nts = g_hash_table_lookup(elems_atual, $1);
						  nts = realloc(nts, sizeof(char)*(strlen(nts)+strlen($2)+2));
						  strcat(nts, ", ");
						  strcat(nts, $2);
					  }
				  }
				}
  | SN STRs		{ GHashTable* elems_atual = g_hash_table_lookup(conceitos, conceito_atual);
  				  if (elems_atual != NULL) {
					  if (!g_hash_table_contains(elems_atual, $1)) {
						  g_hash_table_insert(elems_atual, $1, $2); 
					  }
					  else {
					      char *nts = g_hash_table_lookup(elems_atual, $1);
						  nts = realloc(nts, sizeof(char)*(strlen(nts)+strlen($2)+2));
						  strcat(nts, ", ");
						  strcat(nts, $2);
					  }
				  }
				}
  | USE STRs	{ GHashTable* elems_atual = g_hash_table_lookup(conceitos, conceito_atual);
  				  if (elems_atual != NULL) {
					  if (!g_hash_table_contains(elems_atual, $1)) {
						  g_hash_table_insert(elems_atual, $1, $2); 
					  }
					  else {
					      char *nts = g_hash_table_lookup(elems_atual, $1);
						  nts = realloc(nts, sizeof(char)*(strlen(nts)+strlen($2)+2));
						  strcat(nts, ", ");
						  strcat(nts, $2);
					  }
				  }
				}
  | UF STRs		{ GHashTable* elems_atual = g_hash_table_lookup(conceitos, conceito_atual);
  				  if (elems_atual != NULL) {
					  if (!g_hash_table_contains(elems_atual, $1)) {
						  g_hash_table_insert(elems_atual, $1, $2); 
					  }
					  else {
					      char *nts = g_hash_table_lookup(elems_atual, $1);
						  nts = realloc(nts, sizeof(char)*(strlen(nts)+strlen($2)+2));
						  strcat(nts, ", ");
						  strcat(nts, $2);
					  }
				  }
				}
  | TT STRs		{ GHashTable* elems_atual = g_hash_table_lookup(conceitos, conceito_atual);
  				  if (elems_atual != NULL) {
					  if (!g_hash_table_contains(elems_atual, $1)) {
						  g_hash_table_insert(elems_atual, $1, $2); 
					  }
					  else {
					      char *nts = g_hash_table_lookup(elems_atual, $1);
						  nts = realloc(nts, sizeof(char)*(strlen(nts)+strlen($2)+2));
						  strcat(nts, ", ");
						  strcat(nts, $2);
					  }
				  }
				}
  ;

STRs : STR			{ $$ = $1; }
     | STRs ',' STR	{ asprintf(&$$, "%s,%s", $1, $3); }
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
	printf("Key: %s\n", (char*) key);
	g_hash_table_foreach(value, (GHFunc)iterator_dentro, NULL);
}

void print_hash(GHashTable* hash){
	printf("\n==== Começou ====\n");
	g_hash_table_foreach(hash, (GHFunc)iterator_fora, NULL);
	printf("==== Acabou ====\n\n");
}


int main(){
	conceitos = g_hash_table_new(g_str_hash, g_str_equal);
	elems_atual = g_hash_table_new(g_str_hash, g_str_equal);
	strs = g_array_new(FALSE, FALSE, sizeof(char*));
	yyparse();
	g_hash_table_foreach(conceitos, (GHFunc)iterator_fora, NULL);

    //geração da página html com base na estrutura de dados
    FILE* fp = fopen("index.html", "a");

    fprintf(fp, "<!DOCTYPE html>\n<html>\n<body>\n");

    GHashTableIter iter;
    gpointer key, value;

    g_hash_table_iter_init (&iter, conceitos);
    while (g_hash_table_iter_next (&iter, &key, &value)){

        //criação da entrada no ficheiro index.html
        fprintf(fp, "<p> <a href=\"%s.html\">%s</a> </p>", key, key);

        //criação da string com o nome do ficheiro
        char* file_name;
        asprintf(file_name, "%s.html", key);
        //abertura do ficheiro do conceito
        FILE* fp_aux = fopen(file_name, "a");

        //inicialização do ficheiro do conceito
        fprintf(fp_aux, "<!DOCTYPE html>\n<html>\n<body>\n");

        GHashTableIter iter1;
        gpointer key1, value1;

        while (g_hash_table_iter_next (&iter1, &key1, &value1)){

            fprintf(fp_aux, "\t<p>%s: ", key1);

            char** tokens;
            tokens = str_split(value1, ',');

            if (tokens){
                int i;

                //AQUI ACHO QUE VAMOS TER PROBLEMAS NO MATCH POR CAUSA DE EVENTUAIS DIFERENÇAS NOS ESPAÇOS
                if (g_hash_table_contains(conceitos, *(tokens))){
                    fprintf(fp_aux, "<a href=\"%s.html\" %s /a>", *tokens, *tokens);
                }
                else {
                    fprintf(fp_aux, "%s", *tokens);
                }
                free(*tokens);
                for (i = 1; *(tokens + i); i++){
                    if (g_hash_table_contains(conceitos, *(tokens + i))){
                        fprintf(fp_aux, ", <a href=\"%s.html\" %s /a>", *(tokens + i), *(tokens + i));
                    }
                    else {
                        fprintf(fp_aux, ", %s", *(tokens + i));
                    }
                    free(*(tokens + i));
                }
                free(tokens);
            }
            fprintf(fp_aux, "</p>\n");
        }

        //fecho do ficheiro de inicialização
        fprintf(fp_aux, "</body>\n</html>");
        close(fp_aux);
    }

    fprintf(fp, "</body>\n</html>");
    close(fp);


	return 0;
}

void yyerror(char* erro){
	fprintf(stderr, "%s, %s, %d", erro, yytext, yylineno);
}
