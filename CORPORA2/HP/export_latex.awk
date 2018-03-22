BEGIN {
	FS=",";
	print "\\documentclass[a4paper]{article}\n\\usepackage[utf8]{inputenc}\n\\usepackage[portuguese]{babel}\n\\usepackage[pdftex]{hyperref}\n\\usepackage{graphicx}\n\\usepackage{listings}\n\n\n\\begin{document}\n\n\\begin{figure}[h!]\\centering\\includegraphics[width=9cm]{./output.png}\\caption{Comparativo do número de menções das diversas personagens entre os livros \n \"Harry Potter e a Pedra Filosofal\" (HP1) e \"Harry Potter e a Câmara dos Segredos\" (HP2).}\\label{fig:plot}\\end{figure}\n\n\\begin{itemize}" > "lista_pers_harry_potter.tex";
}

NF == 3 { print "\t\\item \\textbf{" $2 "} - " $3 " [ " $1 " ]" > "lista_pers_harry_potter.tex" } 
NF == 2 { print "\t\\item \\textbf{" $2 "} [ " $1 " ]" > "lista_pers_harry_potter.tex" } 

END {
	print "\\end{itemize}\n\n\\end{document}" > "lista_pers_harry_potter.tex";
}
