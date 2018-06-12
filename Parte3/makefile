CC = gcc
CFLAGS = -Wall -g `pkg-config --cflags glib-2.0`
LIBS = `pkg-config --libs glib-2.0`

thesaurus2html : y.tab.o lex.yy.o
	$(CC) $(CFLAGS) -o thesaurus2html y.tab.o lex.yy.o -lfl $(LIBS)
	mkdir -p html_files

y.tab.o : y.tab.c 
	$(CC) $(CFLAGS) -c y.tab.c $(LIBS)

lex.yy.o : lex.yy.c y.tab.h
	$(CC) $(CFLAGS) -c lex.yy.c $(LIBS)

y.tab.c y.tab.h : thesaurus2html.y
	yacc -d thesaurus2html.y --verbose

lex.yy.c : thesaurus2html.l
	flex thesaurus2html.l

clean :
	rm lex.* y.* thesaurus2html
	rm -r html_files
