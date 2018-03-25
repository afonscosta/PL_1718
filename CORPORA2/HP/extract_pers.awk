#!/usr/bin/gawk -f

NF > 0 && $4 ~ "^NP.*" && length($2) > 2 { 
	gsub(/_/, " ", $2); #Substitui o '_' por um espaço
	personagens[$2]++
} 

END { 

	PROCINFO["sorted_in"] = "@val_num_desc"

	for ( i in personagens )  {
		print personagens[i] "," i
	}
}
