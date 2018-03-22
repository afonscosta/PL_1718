#!/bin/bash -x

# Extrai os nomes próprios dos ficheiros dados e coloca no ficheiro
# csv chamado 'pers_freq_sort.csv' com o formato: FREQUENCIA,NOME
gawk -f extract_pers.awk ../harrypotter1 ../harrypotter2 > pers_freq_sort.csv

# Percorre o dataset das biografias das personagens e produz um ficheiro
# csv chamado pers_bio_sort_freq.csv com o formato: FREQUENCIA,NOME,BIOGRAFIA
gawk -f add_bio.awk pers_freq_sort.csv characters.csv


#Trata do plot
gawk -f extract_pers.awk ../harrypotter1 > pers_freq_sort_hp1.csv
gawk -f extract_pers.awk ../harrypotter2 > pers_freq_sort_hp2.csv


#gawk -f swap_col.awk pers_freq_sort_hp1.csv > hp1.dat
#gawk -f swap_col.awk pers_freq_sort_hp2.csv > hp2.dat
#Cria o .dat para usar no plot
gawk -f swap_col.awk pers_freq_sort_hp1.csv pers_freq_sort_hp2.csv > hp.dat
gnuplot plot.dat

# Percorre o ficheiro pers_bio_sort_freq.csv e produz o ficheiro latex
# chamado lista_pers_harry_potter.tex em formato de lista
gawk -f export_latex.awk pers_bio_sort_freq.csv

#Produz pdf
pdflatex lista_pers_harry_potter.tex &> /dev/null
rm lista_pers_harry_potter.aux
rm lista_pers_harry_potter.log
rm lista_pers_harry_potter.out


#gnuplot d1.dat
