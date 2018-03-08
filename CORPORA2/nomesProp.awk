#!/usr/bin/gawk -f

NF > 0 && NR >= 315 { 
	if ($5 == "NP" && length($2) > 2 && $9 !~ /\(grup-nom/ && $9 ~ /\(w-[fm]s/) print NR, $2, $5, $9
} 
