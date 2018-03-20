#!/usr/bin/gawk -f

NF > 0 && $4 !~ /^F.*/ {
	dic_palavras[$2]++;
	dic_lemas[$2][$3]++;
	dicionario[$2][$3][$4]++;
}

END{
	asorti(dic_palavras, palavras);
	for(i in palavras){
		asorti(dic_lemas[palavras[i]], lemas);
		print palavras[i], ":";
		for(j in lemas[palavras[i]]){
			asorti(dicionario[palavras[i]][lemas[j]], pos);
			print lemas[j], ":";
			for(k in pos){
				print pos[k], " -- ", dicionario[palavras[i]][lemas[j]][pos[k]];
			}
		}
	}
}
