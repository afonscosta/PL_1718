#!/usr/bin/gawk -f

        #HTML
BEGIN { 
        print "<html>\n<head><meta charset=\"UTF-8\"></head>\n<body>\n\n<h1 align=""\"center\""">Verbos</h1>" > "verbos.html"
        print "<html>\n<head><meta charset=\"UTF-8\"></head>\n<body>\n\n<h1 align=""\"center\""">Adjetivos</h1>" > "adjetivos.html"
        print "<html>\n<head><meta charset=\"UTF-8\"></head>\n<body>\n\n<h1 align=""\"center\""">Advérbios</h1>" > "adverbios.html"
        print "<html>\n<head><meta charset=\"UTF-8\"></head>\n<body>\n\n<h1 align=""\"center\""">Substantivos</h1>" > "substantivos.html"

}
NF > 0 && $4 ~ /^V.*/ { 
        gsub(/_/, " ", $3);
        gsub(/_/, " ", $2);
        verbos_lema[$3]++;
        verbos[$3][$2]++;
} 
NF > 0 && $4 ~ /^A.*/ {
        gsub(/_/, " ", $3);
        gsub(/_/, " ", $2);
        adjetivos_lema[$3]++;
        adjetivos[$3][$2]++;
       
}

NF > 0 && $4 ~ /^R.*/ {
        gsub(/_/, " ", $3);
        gsub(/_/, " ", $2);
        adverbios_lema[$3]++ 
        adverbios[$3][$2]++;
}

NF > 0 && $4 ~ /^N.*/ {
        gsub(/_/, " ", $3);
        gsub(/_/, " ", $2);
        substantivos_lema[$3]++
        substantivos[$3][$2]++;
}


END {   
        
        #CONSTRUCAO DE TABELAS DE TOPS
        
        print "<h2 align=""\"center\""">Top 10 Ocorrências</h2>" > "verbos.html";
        print "\n<table align=""\"center\""" border='3'>\n\t\t" > "verbos.html"; 
        print "<tr bgcolor=""\"grey\""">\n\t\t<th>Lema</th><th>Palavra</th><th>Ocorrências</th>\n\t</tr>" > "verbos.html"

        print "<h2 align=""\"center\""">Top 10 Ocorrências</h2>" > "adjetivos.html";
        print "\n<table align=""\"center\""" border='3'>\n\t\t" > "adjetivos.html"; 
        print "<tr bgcolor=""\"grey\""">\n\t\t<th>Lema</th><th>Palavra</th><th>Ocorrências</th>\n\t</tr>" > "adjetivos.html"

        print "<h2 align=""\"center\""">Top 10 Ocorrências</h2>" > "adverbios.html";
        print "\n<table align=""\"center\""" border='3'>\n\t\t" > "adverbios.html"; 
        print "<tr bgcolor=""\"grey\""">\n\t\t<th>Lema</th><th>Palavra</th><th>Ocorrências</th>\n\t</tr>" > "adverbios.html"

        print "<h2 align=""\"center\""">Top 10 Ocorrências</h2>" > "substantivos.html";
        print "\n<table align=""\"center\""" border='3'>\n\t\t" > "substantivos.html"; 
        print "<tr bgcolor=""\"grey\""">\n\t\t<th>Lema</th><th>Palavra</th><th>Ocorrências</th>\n\t</tr>" > "substantivos.html"

        #PREENCHIMENTO INICIAL DO ARRAY DE TOP
        a = 0;
        for (i in verbos_lema){
            for (j in verbos[i]){
                if (a < 10){
                    top_verbos_palavra[a] = j;
                    top_verbos_lema[a] = i;
                    top_verbos[a] = verbos[i][j]; a++;
                }
                else break;
            }
        }

        a = 0;
        for (i in adjetivos_lema){
            for (j in adjetivos[i]){
                if (a < 10){
                    top_adjetivos_palavra[a] = j;
                    top_adjetivos_lema[a] = i;
                    top_adjetivos[a] = adjetivos[i][j]; a++;
                }
                else break;
            }
        }

        a = 0;
        for (i in adverbios_lema){
            for (j in adverbios[i]){
                if (a < 10){
                    top_adverbios_palavra[a] = j;
                    top_adverbios_lema[a] = i;
                    top_adverbios[a] = adverbios[i][j]; a++;
                }
                else break;
            }
        }

        a = 0;
        for (i in substantivos_lema){
            for (j in substantivos[i]){
                if (a < 10){
                    top_substantivos_palavra[a] = j;
                    top_substantivos_lema[a] = i;
                    top_substantivos[a] = substantivos[i][j]; a++;
                }
                else break;
            }
        }

        #ORDENAÇÃO DO ARRAY DE TOPS

        for (d = 0; d < 10; d++){
            for (b = d; b < 10; b++){
                if (top_verbos[d] < top_verbos[b]){
                    temp = top_verbos[d];
                    top_verbos[d] = top_verbos[b];
                    top_verbos[b] = temp;

                    temp = top_verbos_lema[d];
                    top_verbos_lema[d] = top_verbos_lema[b];
                    top_verbos_lema[b] = temp;

                    temp = top_verbos_palavra[d];
                    top_verbos_palavra[d] = top_verbos_palavra[b];
                    top_verbos_palavra[b] = temp;
                }

                if (top_adjetivos[d] < top_adjetivos[b]){
                    temp = top_adjetivos[d];
                    top_adjetivos[d] = top_adjetivos[b];
                    top_adjetivos[b] = temp;

                    temp = top_adjetivos_lema[d];
                    top_adjetivos_lema[d] = top_adjetivos_lema[b];
                    top_adjetivos_lema[b] = temp;

                    temp = top_adjetivos_palavra[d];
                    top_adjetivos_palavra[d] = top_adjetivos_palavra[b];
                    top_adjetivos_palavra[b] = temp;
                }

                if (top_adverbios[d] < top_adverbios[b]){
                    temp = top_adverbios[d];
                    top_adverbios[d] = top_adverbios[b];
                    top_adverbios[b] = temp;

                    temp = top_adverbios_lema[d];
                    top_adverbios_lema[d] = top_adverbios_lema[b];
                    top_adverbios_lema[b] = temp;

                    temp = top_adverbios_palavra[d];
                    top_adverbios_palavra[d] = top_adverbios_palavra[b];
                    top_adverbios_palavra[b] = temp;
                }
                
                if (top_substantivos[d] < top_substantivos[b]){
                    temp = top_substantivos[d];
                    top_substantivos[d] = top_substantivos[b];
                    top_substantivos[b] = temp;

                    temp = top_substantivos_lema[d];
                    top_substantivos_lema[d] = top_substantivos_lema[b];
                    top_substantivos_lema[b] = temp;

                    temp = top_substantivos_palavra[d];
                    top_substantivos_palavra[d] = top_substantivos_palavra[b];
                    top_substantivos_palavra[b] = temp;
                }
            }
        }

        #TRAVESSIA DO FICHEIRO

        for (n in verbos_lema){
            for (o in verbos[n]){

                for(i = 0; i < 10; i++){
                    if (top_verbos[i] < verbos[n][o]){
                        #SHIFT PARA A DIREITA
                        for(j = 9; j < i; j--){
                            top_verbos[j-1] = top_verbos[j];
                            top_verbos_lema[j-1] = top_verbos_lema[j];
                            top_verbos_palavra[j-1] = top_verbos_palavra[j];
                        }
                        top_verbos[i] = verbos[n][o];
                        top_verbos_lema[i] = n;
                        top_verbos_palavra[i] = o;
                        break;
                    }
                }

            }
        }

        for (n in adjetivos_lema){
            for (o in adjetivos[n]){

                for(i = 0; i < 10; i++){
                    if (top_adjetivos[i] < adjetivos[n][o]){
                        #SHIFT PARA A DIREITA
                        for(j = 9; j < i; j--){
                            top_adjetivos[j-1] = top_adjetivos[j];
                            top_adjetivos_lema[j-1] = top_adjetivos_lema[j];
                            top_adjetivos_palavra[j-1] = top_adjetivos_palavra[j];
                        }
                        top_adjetivos[i] = adjetivos[n][o];
                        top_adjetivos_lema[i] = n;
                        top_adjetivos_palavra[i] = o;
                        break;
                    }
                }

            }
        }

        for (n in adverbios_lema){
            for (o in adverbios[n]){

                for(i = 0; i < 10; i++){
                    if (top_adverbios[i] < adverbios[n][o]){
                        #SHIFT PARA A DIREITA
                        for(j = 9; j < i; j--){
                            top_adverbios[j-1] = top_adverbios[j];
                            top_adverbios_lema[j-1] = top_adverbios_lema[j];
                            top_adverbios_palavra[j-1] = top_adverbios_palavra[j];
                        }
                        top_adverbios[i] = adverbios[n][o];
                        top_adverbios_lema[i] = n;
                        top_adverbios_palavra[i] = o;
                        break;
                    }
                }

            }
        }

        for (n in substantivos_lema){
            for (o in substantivos[n]){

                for(i = 0; i < 10; i++){
                    if (top_substantivos[i] < substantivos[n][o]){
                        #SHIFT PARA A DIREITA
                        for(j = 9; j < i; j--){
                            top_substantivos[j-1] = top_substantivos[j];
                            top_substantivos_lema[j-1] = top_substantivos_lema[j];
                            top_substantivos_palavra[j-1] = top_substantivos_palavra[j];
                        }
                        top_substantivos[i] = substantivos[n][o];
                        top_substantivos_lema[i] = n;
                        top_substantivos_palavra[i] = o;
                        break;
                    }
                }

            }
        }

        for (b = 0; b < 10; b++){
                #print top_verbos[b], top_verbos_lema[b], top_verbos_palavra[b];
                print "<tr>\n\t<td>" top_verbos_lema[b] "</td><td>" top_verbos_palavra[b] "</td><td>"top_verbos[b]"</td>\n</tr>\n" > "verbos.html";

                #print "adjetivos", top_adjetivos[b], top_adjetivos_lema[b], top_adjetivos_palavra[b];
                print "<tr>\n\t<td>" top_adjetivos_lema[b] "</td><td>" top_adjetivos_palavra[b] "</td><td>" top_adjetivos[b] "</td>\n</tr>\n" > "adjetivos.html";

                #print "adjetivos", top_adjetivos[b], top_adjetivos_lema[b], top_adjetivos_palavra[b];
                print "<tr>\n\t<td>" top_adverbios_lema[b] "</td><td>" top_adverbios_palavra[b] "</td><td>" top_adverbios[b] "</td>\n</tr>\n" > "adverbios.html";

                #print "adjetivos", top_adjetivos[b], top_adjetivos_lema[b], top_adjetivos_palavra[b];
                print "<tr>\n\t<td>" top_substantivos_lema[b] "</td><td>" top_substantivos_palavra[b] "</td><td>" top_substantivos[b] "</td>\n</tr>\n" > "substantivos.html";
        }

        #HTML
        print "\t</table>" > "verbos.html";
        print "\t</table>" > "adjetivos.html";
        print "\t</table>" > "adverbios.html";
        print "\t</table>" > "substantivos.html";


        print "<h2 align=""\"center\""">Todas as ocorrências de verbos</h2>" > "verbos.html";
        print "<h2 align=""\"center\""">Todas as ocorrências de adjetivos</h2>" > "adjetivos.html";
        print "<h2 align=""\"center\""">Todas as ocorrências de advérbios</h2>" > "adverbios.html";
        print "<h2 align=""\"center\""">Todas as ocorrências de substantivos</h2>" > "substantivos.html";


        print "<table bgcolor=""\"#f2f2f2\""" align=""\"center\""" border='3'>" > "verbos.html"
        print "<table bgcolor=""\"#f2f2f2\""" align=""\"center\""" border='3'>" > "adjetivos.html"
        print "<table bgcolor=""\"#f2f2f2\""" align=""\"center\""" border='3'>" > "adverbios.html"
        print "<table bgcolor=""\"#f2f2f2\""" align=""\"center\""" border='3'>" > "substantivos.html"

        print "\t<tr bgcolor=""\"grey\""">\n\t\t<th>Lema</th>\n\t\t<th>Palavra</th>\n\t\t<th>Ocorrências</th>\n\t</tr>" > "verbos.html"
        print "\t<tr bgcolor=""\"grey\""">\n\t\t<th>Lema</th>\n\t\t<th>Palavra</th>\n\t\t<th>Ocorrências</th>\n\t</tr>" > "adjetivos.html"
        print "\t<tr bgcolor=""\"grey\""">\n\t\t<th>Lema</th>\n\t\t<th>Palavra</th>\n\t\t<th>Ocorrências</th>\n\t</tr>" > "adverbios.html"
        print "\t<tr bgcolor=""\"grey\""">\n\t\t<th>Lema</th>\n\t\t<th>Palavra</th>\n\t\t<th>Ocorrências</th>\n\t</tr>" > "substantivos.html"

        #VERBOS
        asorti(verbos_lema, verbos_lema_sort); 
        for (i in verbos_lema_sort){
                asorti(verbos[verbos_lema_sort[i]], verbos_palavras);
                print verbos_lema_sort[i], ":" > "verbos.txt";

                for (a in verbos_palavras) conta++;

                #HTML
                print "\t<tr bgcolor=""\"#bfbfbf\""" align=""center"">\n\t\t<td rowspan="conta+1">"verbos_lema_sort[i]"</td>\n\t</tr>" > "verbos.html";

                for (j in verbos_palavras){
                        print  verbos_palavras[j], " -> ", verbos[verbos_lema_sort[i]][verbos_palavras[j]] > "verbos.txt";
                        #HTML
                        print "\t<tr>\n\t\t<td>"verbos_palavras[j]"</td>\n\t\t<td>"verbos[verbos_lema_sort[i]][verbos_palavras[j]]"</td>\n\t</tr>" > "verbos.html";
               }
               conta = 0;
        }
        
        #ADJETIVOS
        asorti(adjetivos_lema, adjetivos_lema_sort);
        for (i in adjetivos_lema_sort){
                asorti(adjetivos[adjetivos_lema_sort[i]], adjetivos_palavras);
                print adjetivos_lema_sort[i], ":" > "adjetivos.txt";

                for (a in adjetivos_palavras) conta++;

                #HTML
                print "\t<tr bgcolor=""\"#bfbfbf\""" align=""center"">\n\t\t<td rowspan="conta+1">"adjetivos_lema_sort[i]"</td>\n\t</tr>" > "adjetivos.html";
                #print "\t<tr>\n\t\t<td rowspan="adjetivos_lema[adjetivos_lema_sort[i]]">"adjetivos_lema_sort[i]"</td>\n\t</tr>" > "table.html";
                #print "\t<tr>\n\t\t<td>"adjetivos_lema_sort[i]"</td>\n\t</tr>" > "table.html";

                for (j in adjetivos_palavras){
                        print  adjetivos_palavras[j], " -> ", adjetivos[adjetivos_lema_sort[i]][adjetivos_palavras[j]] > "adjetivos.txt";
                        #HTML
                        print "\t<tr>\n\t\t<td>"adjetivos_palavras[j]"</td>\n\t\t<td>"adjetivos[adjetivos_lema_sort[i]][adjetivos_palavras[j]]"</td>\n\t</tr>" > "adjetivos.html";
                }
                conta = 0;
        }

        #ADVERBIOS
        asorti(adverbios_lema, adverbios_lema_sort);
        for (i in adverbios_lema_sort){
                asorti(adverbios[adverbios_lema_sort[i]], adverbios_palavras);
                print adverbios_lema_sort[i], ":" > "adverbios.txt";

                for (a in adverbios_palavras) conta++;

                #HTML
                print "\t<tr bgcolor=""\"#bfbfbf\""" align=""center"">\n\t\t<td rowspan="conta+1">"adverbios_lema_sort[i]"</td>\n\t</tr>" > "adverbios.html";

                for (j in adverbios_palavras){
                        print  adverbios_palavras[j], " -> ", adverbios[adverbios_lema_sort[i]][adverbios_palavras[j]] > "adverbios.txt";
                        #HTML
                        print "\t<tr>\n\t\t<td>"adverbios_palavras[j]"</td>\n\t\t<td>"adverbios[adverbios_lema_sort[i]][adverbios_palavras[j]]"</td>\n\t</tr>" > "adverbios.html";
                }
                conta = 0;
        }

        #SUBSTANTIVOS
        asorti(substantivos_lema, substantivos_lema_sort);
        for (i in substantivos_lema_sort){
                asorti(substantivos[substantivos_lema_sort[i]], substantivos_palavras);
                print substantivos_lema_sort[i], ":" > "substantivos.txt";

                for (a in substantivos_palavras) conta++;

                #HTML
                print "\t<tr bgcolor=""\"#bfbfbf\""" align=""center"">\n\t\t<td rowspan="conta+1">"substantivos_lema_sort[i]"</td>\n\t</tr>" > "substantivos.html";
                for (j in substantivos_palavras){
                        print  substantivos_palavras[j], " -> ", substantivos[substantivos_lema_sort[i]][substantivos_palavras[j]] > "substantivos.txt";
                        #HTML
                        print "\t<tr>\n\t\t<td>"substantivos_palavras[j]"</td>\n\t\t<td>"substantivos[substantivos_lema_sort[i]][substantivos_palavras[j]]"</td>\n\t</tr>" > "substantivos.html";
                }
                conta = 0;
        }

        
        print "</table>\n</body>\n</html>" > "verbos.html";
        print "</table>\n</body>\n</html>" > "adjetivos.html";
        print "</table>\n</body>\n</html>" > "adverbios.html";
        print "</table>\n</body>\n</html>" > "substantivos.html";

}
