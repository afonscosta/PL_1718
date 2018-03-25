#!/usr/bin/gawk -f


NF > 0 && $4 !~ /^F.+/ && $4 !~ /-/ {
    dic_palavras[$3]++;
    dicionario[$3][$2, $4]++;
}

END{
    print "<?xml version=\"1.0\" ?>" > "dict.xml";
    print "<dicionario>" > "dict.xml";
    asorti(dic_palavras, palavras);
    for(i in palavras){
        asorti(dicionario[palavras[i]], definicoes);
	gsub(/&/, "&amp;", palavras[i]);
	print "  <lema id=\""palavras[i]"\">" > "dict.xml";
        for(j in definicoes){
	    split(definicoes[j],pos, SUBSEP, seps);
	    gsub(/&/, "&amp;", pos[1]);
	    gsub(/\"/, "&quot;", pos[1]);
	    print "    <palavra id=\""pos[1]"\">" > "dict.xml";
	    print "      <pos>"pos[2]"</pos>"  > "dict.xml";
	    print "    </palavra>"  > "dict.xml";
        }
	print "  </lema>" > "dict.xml";
    }
    print "</dicionario>" > "dict.xml";
}
