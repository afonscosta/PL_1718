#!/usr/bin/gawk -f

NF > 0 && $5 !~ /^F.*/ {
    dic_palavras[$3]++;
    dicionario[$3][$2, $5]++;
}

END{
    asorti(dic_palavras, palavras);
    for(i in palavras){
        #asorti(dicionario[palavras[i]], definicoes);
        print palavras[i], ":";
	#print palavras[i], ":";
        #for(j in definicoes){
	#    split(definicoes[j],pos, SUBSEP, seps);
        #    print pos[1], "»» ", pos[2];#,  "-- ", dicionario[palavras[i]][definicoes[j]];
        #}
    }
}
