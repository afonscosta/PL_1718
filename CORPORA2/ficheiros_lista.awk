#!/usr/bin/gawk -f

        #HTML
BEGIN { 
        print "<html>\n<body>\n\n<h2 align=""center"">Adjetivos</h2><table bgcolor=""\"#f2f2f2\""" align=""center"" border='3'>" > "table.html"
        print "\t<tr bgcolor=""\"grey\""">\n\t\t<th>Lema</th>\n\t\t<th>Palavra</th>\n\t\t<th>Ocorrências\n\t</tr>" > "table.html"
}

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

                for (a in adjetivos_palavras) conta++;

                #HTML
                print "\t<tr bgcolor=""\"#bfbfbf\""" align=""center"">\n\t\t<td rowspan="conta+1">"adjetivos_lema_sort[i]"</td>\n\t</tr>" > "table.html";
                #print "\t<tr>\n\t\t<td rowspan="adjetivos_lema[adjetivos_lema_sort[i]]">"adjetivos_lema_sort[i]"</td>\n\t</tr>" > "table.html";
                #print "\t<tr>\n\t\t<td>"adjetivos_lema_sort[i]"</td>\n\t</tr>" > "table.html";

                for (j in adjetivos_palavras){
                        print  adjetivos_palavras[j], " -> ", adjetivos[adjetivos_lema_sort[i]][adjetivos_palavras[j]] > "adjetivos.txt";
                        #HTML
                        print "\t<tr>\n\t\t<td>"adjetivos_palavras[j]"</td>\n\t\t<td>"adjetivos[adjetivos_lema_sort[i]][adjetivos_palavras[j]]"</td>\n\t</tr>" > "table.html";
                }
                conta = 0;
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

        #HTML
        print "\t</table>\n\t</body>\n</html>" > "table.html";
 }
