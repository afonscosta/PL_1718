BEGIN {
	FS=",";
	print "\\documentclass[a4paper]{article}\n"
	print "\\usepackage[utf8]{inputenc}\n"
	print "\\usepackage[portuguese]{babel}\n"
	print "\\usepackage[pdftex]{hyperref}\n"
	print "\\usepackage{graphicx}\n"
	print "\\usepackage{listings}\n\n"

	print "\\hypersetup{colorlinks=true, linkcolor=blue}"

	print "\\begin{document}"

	print "\\begin{titlepage}"
	print "\\begin{center}"

	print "\\includegraphics[width=0.4\\textwidth]{./imagens/logo.jpg}\\\\[0.5cm]"

	print "\\vspace{10mm}"

	print "{\\huge Universidade do Minho - Escola de Engenharia}\\\\[0.5cm]"

	print "{\\large Processamento de Linguagens}\\\\[0.5cm]"

	print "\\vspace{10mm}"

	print "% Title"
	print "\\rule{\\linewidth}{0.5mm} \\\\[0.4cm]"
	print "{ \\huge \\bfseries Listas das personagens do Harry Potter \\\\[0.4cm] }"
	print "\\rule{\\linewidth}{0.5mm} \\\\[1.5cm]"

	print "% Author and supervisor"
	print "\\noindent"
	print "\\begin{minipage}{0.4\\textwidth}"
	print "  \\begin{flushleft} \\large"
	print "    \\emph{Autores :}\\\\"
	print "    Daniel Maia \\textsc{(A77531)}\\\\"
	print "    \\includegraphics[width=1.5cm]{./imagens/daniel.jpg}\\break"
	print "    Diogo Silva\\textsc{(A78034)}\\\\"
	print "    \\includegraphics[width=1.5cm]{./imagens/afonso.jpg}\\break"
	print "    Marco Silva\\textsc{(A79607)}\\\\"
	print "    \\includegraphics[width=1.5cm]{./imagens/marco.jpg}\\break"
	print "  \\end{flushleft}"
	print "\\end{minipage}%"
	print "\\vfill"

	print "% Bottom of the page"
	print "{\\large Versão 1.0 \\\\ \\today}"

	print "\\end{center}"
	print "\\end{titlepage}"

	print "\\pagebreak"
	print "\\tableofcontents"

	print "\\section{Introdução}"

	print "Este documento é o resultado do processamento, através da ferramenta \\textit{GAWK}, de textos preanotados com Freeling. Efetivamente, foram usados os dois primeiros livros da saga \\textit{Harry Potter}, nomeadamente o \\textbf{Harry Potter e a Pedra Filosofal} e o \\textbf{Harry Potter e a Câmara dos Segredos}."

	print "\\section{Número de ocorrências das personagens}"

	print "\\begin{figure}[h!]"
	print "\\centering"
	print "\\includegraphics[width=9cm]{./imagens/output.png}"
	print "\\caption{Comparativo do número de menções das diversas personagens entre os livros \"Harry Potter e a Pedra Filosofal\" (HP1) e \"Harry Potter e a Câmara dos Segredos\" (HP2).}"
	print "\\label{fig:plot}"
	print "\\end{figure}"

	print "O comparativo presente no gráfico permite concluir informações bastantes curiosas. Nomeadamente, que a personagem \textit{Harry Potter é mais mencionada no segundo livro. Mais ainda no primeiro livro a personagem \\textit{Hagrid} é a terceira mais frequente, no entanto no segundo livro esta passa a ser a \\textit{Hermione}. O mesmo acontece com o \textit{Snape} e o \\textit{Dumbledore}, respetivamente."

	print "\\newpage"

	print "\\section{Lista das personagens presentes nos livros}"

	print "\\hspace{4mm} A lista das personagens que se encontra nesta secção é o resultado do parse dos documentos anotados com \\textit{Freeling}. No entanto, estes documentos não estão corretos na sua totalidade e como tal existe algumas palavras na lista abaixo que não são personagens, mas que foram consideradas como nome próprio. Nestes casos torna-se impossível resolver os conflitos em questão e como tal encontram-se na lista final."

	print "\\subsection{Índice}"

	print "\\hspace{4mm} \\hyperlink{A}{A}"
	print "\\hyperlink{B}{B}"
	print "\\hyperlink{C}{C}"
	print "\\hyperlink{D}{D}"
	print "\\hyperlink{E}{E}"
	print "\\hyperlink{F}{F}"
	print "\\hyperlink{G}{G}"
	print "\\hyperlink{H}{H}"
	print "\\hyperlink{I}{I}"
	print "\\hyperlink{J}{J}"
	print "\\hyperlink{K}{K}"
	print "\\hyperlink{L}{L}"
	print "\\hyperlink{M}{M}"
	print "\\hyperlink{N}{N}"
	print "\\hyperlink{O}{O}"
	print "\\hyperlink{P}{P}"
	print "\\hyperlink{Q}{Q}"
	print "\\hyperlink{R}{R}"
	print "\\hyperlink{S}{S}"
	print "\\hyperlink{T}{T}"
	print "\\hyperlink{U}{U}"
	print "\\hyperlink{V}{V}"
	print "\\hyperlink{W}{W}"
	print "\\hyperlink{X}{X}"
	print "\\hyperlink{Y}{Y}"
	print "\\hyperlink{Z}{Z}"

	print "\\subsection{Lista das personagens ordenada alfabeticamente}"

	print "\\begin{itemize}"
}

NF == 2 { 
	if (substr($2, 1, 1) in chars) 
		print "\t\\item \\textbf{" $2 "} [ " $1 " ]";
	else {
		chars[substr($2, 1, 1)] = "";
		print "\t\\item \\hypertarget{"substr($2,1,1)"}{\\textbf{" $2 "}} [ " $1 " ]";
	}
} 

NF == 3 { 
	if (substr($2, 1, 1) in chars) 
		print "\t\\item \\textbf{" $2 "} - " $3 " [ " $1 " ]" 
	else {
		chars[substr($2, 1, 1)] = "";
		print "\t\\item \\hypertarget{"substr($2,1,1)"}{" $2 "} [ " $1 " ]";
		print "\t\\item \\hypertarget{"substr($2,1,1)"}{\\textbf{" $2 "}} - " $3 " [ " $1 " ]";
	}
}


END {
	print "\\end{itemize}\n\n\\end{document}";
}
