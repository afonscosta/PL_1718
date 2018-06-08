%{
#include <stdio.h>
#include <stdlib.h>
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
	return 0;
}

void yyerror(char* erro){
	fprintf(stderr, "%s, %s, %d", erro, yytext, yylineno);
}
