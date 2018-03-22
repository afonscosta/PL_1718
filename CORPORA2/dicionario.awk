#!/usr/bin/gawk -f


NF > 0 && $5 !~ /^F.*/ {
    dic_palavras[$3]++;
    dicionario[$3][$2, $5]++;
}

END{
    #printf("<?xml version=\"1.0\" ?>\n");
    print "<?xml version=\"1.0\" ?>" > "dict.xml";
    #printf("<dicionario>\n");
    print "<dicionario>" > "dict.xml";
    asorti(dic_palavras, palavras);
    for(i in palavras){
        asorti(dicionario[palavras[i]], definicoes);
	#printf("  <lema>%s\n", palavras[i]);
        #print palavras[i], ":";
	print "  <lema>", palavras[i] > "dict.xml";
        for(j in definicoes){
	    split(definicoes[j],pos, SUBSEP, seps);
	    #printf("    <palavra>%s\n", pos[1]);
	    print "    <palavra>", pos[1] > "dict.xml";
	    #printf("    <pos>%s</pos>\n", pos[2]);
	    print "    <pos>", pos[2]  > "dict.xml";
	    #printf("    </palavra>\n");
	    print "    </palavra>"  > "dict.xml";
            #print "	", pos[1], "»» ", pos[2];#,  "-- ", dicionario[palavras[i]][definicoes[j]];
        }
	#printf("  </lema>\n");
	print "  </lema>" > "dict.xml";
    }
    #printf("</dicionario>");
    print "</dicionario>" > "dict.xml";
}
