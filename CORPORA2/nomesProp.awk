#!/usr/bin/gawk -f

NF > 0 && NR >= 315 && $5 == "NP" { 
	personagens[$2]++
} 

END { for ( i in personagens ) print personagens[i], " -> ", i }
