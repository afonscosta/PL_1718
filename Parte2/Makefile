
marktex: lex.yy.c
	gcc -o marktex lex.yy.c -lfl

lex.yy.c: marktex.l
	flex marktex.l

clean:
	rm lex.yy.c marktex
