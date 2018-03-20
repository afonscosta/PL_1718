#!/usr/bin/gawk -f

NF > 0 && NR >= 315 && $4 ~ /^V.*/ { 
	verbos_lema[$3]++;
        verbos[$3][$2]++;
} 
NF > 0 && NR >= 315 && $4 ~ /^A.*/ {
       adjetivos_lema[$3]++;
       adjetivos[$3][$2]++;
       
}

NF > 0 && NR >= 315 && $4 ~ /^R.*/ {
       adverbios_lema[$3]++ 
       adverbios[$3][$2]++;
}

NF > 0 && NR >= 315 && $4 ~ /^N.*/ {
       substantivos_lema[$3]++
       substantivos[$3][$2]++;
}


#atenção que o ficheiro não é construido por ordem de frequencia mas sim ordem alfabética
END {   
        #VERBOS
        asorti(verbos_lema, verbos_lema_sort); 
        for (i in verbos_lema_sort){
                asorti(verbos[verbos_lema_sort[i]], verbos_palavras);
                print verbos_lema_sort[i], ":" > "verbos.txt";
                for (j in verbos_palavras){
                        print  verbos_palavras[j], " -> ", verbos[verbos_lema_sort[i]][verbos_palavras[j]] > "verbos.txt";
               }
        }
        
        #ADJETIVOS
        asorti(adjetivos_lema, adjetivos_lema_sort);
        for (i in adjetivos_lema_sort){
                asorti(adjetivos[adjetivos_lema_sort[i]], adjetivos_palavras);
                print adjetivos_lema_sort[i], ":" > "adjetivos.txt";
                for (j in adjetivos_palavras){
                        print  adjetivos_palavras[j], " -> ", adjetivos[adjetivos_lema_sort[i]][adjetivos_palavras[j]] > "adjetivos.txt";
                }
        }

        #ADVERBIOS
        asorti(adverbios_lema, adverbios_lema_sort);
        for (i in adverbios_lema_sort){
                asorti(adverbios[adverbios_lema_sort[i]], adverbios_palavras);
                print adverbios_lema_sort[i], ":" > "adverbios.txt";
                for (j in adverbios_palavras){
                        print  adverbios_palavras[j], " -> ", adverbios[adverbios_lema_sort[i]][adverbios_palavras[j]] > "adverbios.txt";
                }
        }

        #SUBSTANTIVOS
        asorti(substantivos_lema, substantivos_lema_sort);
        for (i in substantivos_lema_sort){
                asorti(substantivos[substantivos_lema_sort[i]], substantivos_palavras);
                print substantivos_lema_sort[i], ":" > "substantivos.txt";
                for (j in substantivos_palavras){
                        print  substantivos_palavras[j], " -> ", substantivos[substantivos_lema_sort[i]][substantivos_palavras[j]] > "substantivos.txt";
                }
        }

     #asorti(adjetivos, adjetivos_aux); for (i in adjetivos_aux) print adjetivos_aux[i], " -> ", adjetivos[adjetivos_aux[i]] > "adjetivos.txt";
     #asorti(adverbios, adverbios_aux); for (i in adverbios_aux) print adverbios_aux[i], " -> ", adverbios[adverbios_aux[i]] > "adverbios.txt";    
     #asorti(substantivos, substantivos_aux); for (i in substantivos_aux) print substantivos_aux[i], " -> ", substantivos[substantivos_aux[i]] > "substantivos.txt";    
 }
