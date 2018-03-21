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
            print definicoes[j], " -- ", dicionario[palavras[i]][definicoes[j]];
        }
    }
}
