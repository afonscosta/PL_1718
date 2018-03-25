#!/usr/bin/gawk -f
BEGIN {
	if (ARGC == 2) {
		if (ARGV[1] == "../harrypotter1") 
			init1 = 315;
		else if (ARGV[1] == "../harrypotter2") 
			init1 = 106;
	}

	if (ARGC == 3) {
		if (ARGV[1] == "../harrypotter1") 
			init1 = 315;
		else if (ARGV[1] == "../harrypotter2") 
			init1 = 106;
		if (ARGV[2] == "../harrypotter1") 
			init2 = 315
		else if (ARGV[2] == "../harrypotter2") 
			init2 = 106
	}
}

ARGIND == 1 && NF > 0 && FNR >= init1 && $4 ~ "^NP.*" && length($2) > 2 { 
	gsub(/_/, " ", $2); #Substitui o '_' por um espaço
	personagens[$2]++
} 

ARGIND == 2 && NF > 0 && FNR >= init2 && $4 ~ "^NP.*" && length($2) > 2 { 
	gsub(/_/, " ", $2); #Substitui o '_' por um espaço
	personagens[$2]++
} 

END { 

	PROCINFO["sorted_in"] = "@val_num_desc"

	for ( i in personagens )  {
		print personagens[i] "," i
	}
}
