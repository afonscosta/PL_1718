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

char* remove_esp_ex( char* string);
void complete_inv(char* conceito_atual, char* id, GArray* strs_atual);
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
					  removeSpaces($1);
					  if (!g_hash_table_contains(elems_atual, $1)) {
						  GArray* strs = g_array_new(FALSE, FALSE, sizeof(char*));
						  g_array_append_val(strs, $2);
						  g_hash_table_insert(elems_atual, $1, strs); 
						  complete_inv(conceito_atual, $1, strs);
					  }
					  else {
						  GArray* strs = (GArray*) g_hash_table_lookup(elems_atual, $1);
						  g_array_append_val(strs, $2);
						  g_hash_table_insert(elems_atual, $1, strs); 
						  complete_inv(conceito_atual, $1, strs);
					  }
				  }
				}
  | ID STRs		{ GHashTable* elems_atual = g_hash_table_lookup(conceitos, conceito_atual);
  				  if (elems_atual != NULL) {
					  removeSpaces($1);
					  if (!g_hash_table_contains(elems_atual, $1)) {
						  GArray* strs = g_array_new(FALSE, FALSE, sizeof(char*));
						  char** tokens;
						  tokens = str_split($2, ',');
						  for(int i = 0; tokens[i]; i++) {
							  g_array_append_val(strs, tokens[i]);
						  }
						  g_hash_table_insert(elems_atual, $1, strs); 
						  complete_inv(conceito_atual, $1, strs);
					  }
					  else {
						  GArray* strs = (GArray*) g_hash_table_lookup(elems_atual, $1);
						  char** tokens;
						  tokens = str_split($2, ',');
						  for(int i = 0; tokens[i]; i++) {
							  g_array_append_val(strs, tokens[i]);
						  }
						  g_hash_table_insert(elems_atual, $1, strs); 
						  complete_inv(conceito_atual, $1, strs);
					  }
				  }
				}
  ;

IDs : ID		{ $1 = remove_esp_ex($1); asprintf(&$$, "%s", $1); }
    | IDs ID	{ $2 = remove_esp_ex($2); asprintf(&$$, "%s,%s", $1, $2); }	
    ;

STRs : STR			{ $1 = remove_esp_ex($1); asprintf(&$$, "%s", $1); }
     | STRs ',' STR	{ $3 = remove_esp_ex($3); asprintf(&$$, "%s,%s", $1, $3); }
     ;

TXTs : STR		{ remove_esp_ex($1); asprintf(&$$, "%s", $1); }
     | TXTs STR	{ remove_esp_ex($2); asprintf(&$$, "%s %s", $1, $2); }
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

char* remove_esp_ex( char* string){

	if(string)
	{
		while (*string != '\0' && *string == ' '){
			string++;
		}

		int j = strlen(string) - 1;

		while( j >= 0 && string[j] == ' '){
			string[j] = '\0';
			j--;
		}
	}
	return string;
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

void complete_inv(char* conceito_atual, char* id, GArray* strs_atual)
{
	int existe = 0;
	char *id_fora;
	GHashTable* hash_conceito;
	//Ver o ID do inverso
	char* id_inv = g_hash_table_lookup(inverses, id);
	if (id_inv != NULL)
	{
		for (int i = 0; i < ((GArray*) strs_atual)->len; i++)
		{
			id_fora = g_array_index((GArray*) strs_atual, char*, i);
			//Procura STR nos conceitos
			hash_conceito = g_hash_table_lookup(conceitos, id_fora);
			if (hash_conceito != NULL)
			{
				GArray* strs_dest = (GArray*) g_hash_table_lookup(hash_conceito, id_inv);
				for (int i = 0; i < ((GArray*) strs_dest)->len; i++)
				{
					char *str = g_array_index((GArray*) strs_dest, char*, i);
					if (strcmp(str, conceito_atual) == 0)
						existe = 1;
				}
				if (!existe)
				{
					//Acrescenta ID inverso com o MT
					g_array_append_val(strs_dest, conceito_atual);
				}
				g_hash_table_insert(hash_conceito, id_inv, strs_dest); 
			}
			else
			{
				GArray* strs_dest = g_array_new(FALSE, FALSE, sizeof(char*));
				//Acrescenta ID inverso com o MT
				g_array_append_val(strs_dest, conceito_atual);
				GHashTable* novo_conceito = g_hash_table_new(g_str_hash, g_str_equal);
				g_hash_table_insert(novo_conceito, id_inv, strs_dest); 
			  	g_hash_table_insert(conceitos, id_fora, novo_conceito); 
			}
		}
	}
}

void gera_html()
{
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
        fprintf(fp_aux, "<!DOCTYPE html>\n<html>\n<head>\n\t<meta charset=\"UTF-8\">\n\t<title>%s</title>\n</head>\n<body>\n", (char*) key);
        fprintf(fp_aux, "<h1>%s</h1>", (char*) key);
        fprintf(fp_aux, "<p> <a href=\"index.html\">Index</a> </p>");

        GHashTableIter iter1;
        gpointer key1, value1;
		g_hash_table_iter_init (&iter1, value);

        while (g_hash_table_iter_next (&iter1, &key1, &value1)){

            fprintf(fp_aux, "\t<p>%s: ", (char*) key1);

			for (int i = 0; i < ((GArray*) value1)->len; i++)
			{
				char *id = g_array_index((GArray*) value1, char*, i);
				// Se estiver nos conceitos gera o href
                if (g_hash_table_contains(conceitos, id) && i == 0){
                    fprintf(fp_aux, "<a href=\"%s.html\">%s</a>", id, id);
                }
                else if (g_hash_table_contains(conceitos, id)){
                    fprintf(fp_aux, ", <a href=\"%s.html\">%s</a>", id, id);
                }
				// Gera a palavra normal
                else if (i == 0){
                    fprintf(fp_aux, "%s", id);
                }
                else {
                    fprintf(fp_aux, ", %s", id);
                }
			}
            fprintf(fp_aux, "</p>\n");
        }

        //fecho do ficheiro de inicialização
        fprintf(fp_aux, "</body>\n</html>");
        fclose(fp_aux);
    }

    fprintf(fp, "</body>\n</html>");
    fclose(fp);
}

int main(){
	conceitos = g_hash_table_new(g_str_hash, g_str_equal);
	elems_atual = g_hash_table_new(g_str_hash, g_str_equal);
	descriptions = g_hash_table_new(g_str_hash, g_str_equal);
	inverses = g_hash_table_new(g_str_hash, g_str_equal);

	yyparse();

	//g_hash_table_foreach(conceitos, (GHFunc)iterator_fora, NULL);

	gera_html();
	return 0;
}

void yyerror(char* erro){
	fprintf(stderr, "%s,%s,%d\n", erro, yytext, yylineno);
}
