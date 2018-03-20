#!/usr/bin/gawk -f

NF > 0 && NR >= 315 && $4 ~ /V.*/ { 
	verbos[$3][$2]++
} 
NF > 0 && NR >= 315 && $4 ~ /A.*/ {
       adjetivos[$3][$2]++
}

NF > 0 && NR >= 315 && /pos=adverb/ {
       adverbios[$3][$2]++ 
}

NF > 0 && NR >= 315 && /pos=noun/ {
       substantivos[$3][$2]++ 
}


#atenção que o ficheiro não é construido por ordem de frequencia mas sim ordem alfabética
END {   asorti(verbos, verbos_lema); 
        print verbos["falar"]["falou"];
        print verbos_lema["falou"];
        for ( i in verbos_lema ){
                asort(verbos_lema, verbos_palavra);
                for (j in verbos_palavra)
                        #print verbos_lema[i]; 
                        print verbos_lema[i], " -> ", verbos_palavra[j], " [", verbos[verbos_lema[i]][verbos_palavra[j]] , "] " > "verbos.txt";
                }
     #asorti(adjetivos, adjetivos_aux); for (i in adjetivos_aux) print adjetivos_aux[i], " -> ", adjetivos[adjetivos_aux[i]] > "adjetivos.txt";
     #asorti(adverbios, adverbios_aux); for (i in adverbios_aux) print adverbios_aux[i], " -> ", adverbios[adverbios_aux[i]] > "adverbios.txt";    
     #asorti(substantivos, substantivos_aux); for (i in substantivos_aux) print substantivos_aux[i], " -> ", substantivos[substantivos_aux[i]] > "substantivos.txt";    
     
}
