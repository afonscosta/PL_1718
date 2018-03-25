BEGIN {FS=","}

ARGIND == 1 { personagens[$2] = $1 } 
ARGIND == 2 && FNR > 1 { dataset[$2] = $3 }

END {

	PROCINFO["sorted_in"] = "@ind_str_asc"

	for (pers_name in personagens) {
		encontrou = 0;
		for (pers_name_dataset in dataset) {
			# Vê se existe uma BIO correspondente
			if (pers_name_dataset ~ pers_name && 
				length(dataset[pers_name_dataset]) > 0) {
				print personagens[pers_name] "," pers_name "," dataset[pers_name_dataset];	
				encontrou = 1;
			}
		}
		# Se não encontrou nenhuma BIO então coloca sem nada
		if (encontrou == 0) {
			print personagens[pers_name] "," pers_name;
		}
	}
}
