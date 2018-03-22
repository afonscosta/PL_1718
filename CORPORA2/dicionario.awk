#!/usr/bin/gawk -f

NF > 0 && $4 !~ /^F.*/ {
    dic_palavras[$2]++;
    dicionario[$2][$3, $4]++;
}

END{
    asorti(dic_palavras, palavras);
    for(i in palavras){
        asorti(dicionario[palavras[i]], definicoes);
        print palavras[i], ":";
        for(j in definicoes){
	    split(definicoes[j],pos, SUBSEP, seps);
            print pos[0], "»» ", pos[1], "## ", pos[2],  "-- ", dicionario[palavras[i]][definicoes[j]];
        }
    }
}
