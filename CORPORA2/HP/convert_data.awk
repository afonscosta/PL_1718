#!/usr/bin/gawk -f

BEGIN {FS=","}

ARGIND == 1 && NR < 11 	{ pers_hp1[$2] = $1 }
ARGIND == 2 			{ pers_hp2[$2] = $1 }

END {

	PROCINFO["sorted_in"] = "@val_num_desc"

	print "Title" , "HP1", "HP2"

	for (i in pers_hp1) {
		if (i in pers_hp2)
			print "\"" i "\"", pers_hp1[i], pers_hp2[i]
		else
			print "\"" i "\"", pers_hp1[i], 0
	}
}
