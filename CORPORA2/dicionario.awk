#!/usr/bin/gawk -f


NF > 0 && $5 !~ /^F.*/ {
    dic_palavras[$3]++;
    dicionario[$3][$2, $5]++;
}

END{
    print "<?xml version=\"1.0\" ?>" > "dict.xml";
    print "<dicionario>" > "dict.xml";
    asorti(dic_palavras, palavras);
    for(i in palavras){
        asorti(dicionario[palavras[i]], definicoes);
	print "  <termo>" > "dict.xml";
	gsub(/&/, "&amp;", palavras[i]);
	print "    <lema>", palavras[i], "</lema >" > "dict.xml";
        for(j in definicoes){
	    split(definicoes[j],pos, SUBSEP, seps);
	    gsub(/&/, "&amp;", pos[1]);
	    print "    <palavra>", pos[1] > "dict.xml";
	    print "    <pos>", pos[2], "</pos>"  > "dict.xml";
	    print "    </palavra>"  > "dict.xml";
        }
	print "  </termo>" > "dict.xml";
    }
    print "</dicionario>" > "dict.xml";
}
