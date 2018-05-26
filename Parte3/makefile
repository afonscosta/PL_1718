thesaurus2html : y.tab.o lex.yy.o
	gcc -o thesaurus2html y.tab.o lex.yy.o -ll

y.tab.o : y.tab.c 
	gcc -c y.tab.c

lex.yy.o : lex.yy.c y.tab.h
	gcc -c lex.yy.c

y.tab.c y.tab.h : thesaurus2html.y
	yacc -d thesaurus2html.y

lex.yy.c : thesaurus2html.l
	flex thesaurus2html.l
