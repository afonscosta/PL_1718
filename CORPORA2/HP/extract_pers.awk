#!/usr/bin/gawk -f

NF > 0 && NR >= 315 && $4 ~ "^NP.*" { 
	gsub(/_/, " ", $2); #Substitui o '_' por um espaço
	personagens[$2]++
} 

END { 

	PROCINFO["sorted_in"] = "@val_num_desc"

	for ( i in personagens )  {
		print personagens[i] "," i
	}

	#system("sort -rn personagens_freq.csv > pers_freq_ord.csv && rm personagens_freq.csv")
	#system("sort -k2 -t, -rn personagens_nome.csv > pers_nome_ord.csv && rm personagens_nome.csv")
	#system("sed -e 's/,/ /g' pers_nome_ord.csv > pers_nome_ord.dat && rm pers_nome_ord.csv")
}
