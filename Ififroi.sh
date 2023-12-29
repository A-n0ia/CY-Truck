#!/bin/bash

#Initialisation des variables

nbF=0
d1=0
d2=0
l=0
t=0
s=0
RED='\033[0;31m'
NC='\033[0m'

FILE=$1
if test -f "$FILE"; then
    nbF=1
else
	echo -e "Veuillez passez un nom de fichier existant en 1er argument !"
	exit 2
fi



while getopts "h:d:l:t:s" opt

do
	case $opt in
			h) if [ "$OPTARG" = "elp" ] || [ "$OPTARG" = "" ]
			then
				more -d help.txt
			fi
			;;
			d) if [ "$OPTARG" = "1" ]
			then
				d1=1
			elif [ "$OPTARG" = "2" ]
			then
				d2=1
			else
				echo -e "Veuillez preciser le mode de cette option\n	${RED}N'hesitez pas a utilser le -h pour plus d'information${NC}"
				exit 2
			fi
			
			;;
			l) l=1	
			;;
			s) s=1
			;;			
			f) if [ "$OPTARG" = "" ]
			then
				if [ "${!OPTIND}" != "$nomF" ]
				then
					echo -e "Un nom de fichier existant est attendu après la commande -f\n	${RED}N'hesitez pas a utilser le -help pour plus d'information${NC}"
				fi
			fi
			;;
			\?) echo -e "L'option n'existe pas debilus maximus\n	${RED}Si t'es paumé, n'hesite pas a utilser le -help pour plus d'info !${NC}"
			;;
	esac
done

if [ $# -lt 2 ]
then
	echo "Pas le bon nombre d'arguments :("
	echo "		${RED}N'hesitez pas a utilser le -h pour plus d'information${NC}"
	exit 1
fi

chmod u+x Meteo_Project.c
gcc -o Meteo_Project Meteo_Project.c

#remplacement des ',' par des ';' et des espaces vides par des €
sed 's/,/;/g' $FILE | sed 's/;;/;€;/g' | sed 's/;;/;€;/g'> tmp0.csv

if [ "$d1" = "1" ]
then
	#Découpage des colonnes voulues et suppression de l'en-tête, le tout transférer dans un fichier temporaire
	
	cut -d';' -f6 $FILE | tail -n+2 | sort > tmp1.csv
	#awk '{tab[$1] +=1 END {for (v in tab) {print v","tab[v]} }'
fi


elif [ "$t2" = "1" ]
then
	cut tmp0.csv -d';' -f2,12 | tail -n+2 > tmpT2.csv
	nmbL=`wc -l tmpT2.csv | cut -d' ' -f1`
	./Meteo_Project tmpT2.csv FmpT2.dat $nmbL t2 $type


elif [ "$t3" = "1" ]
then
	cut tmp0.csv -d';' -f1,2,12 | tail -n+2 > tmpT3.csv
	nmbL=`wc -l tmpT3.csv | cut -d' ' -f1`
	./Meteo_Project tmpT3.csv FmpT3.dat $nmbL t3 $type



elif [ "$p1" = "1" ]
then
	#la fonction awk supprime toute les lignes contenant des € (anciennement espaces vides)
	cut tmp0.csv -d';' -f1,7 | tail -n+2 | awk -F";" ' $1!="€" && $2!="€" {print $0} ' > tmpP1.csv
	nmbL=`wc -l tmpP1.csv | cut -d' ' -f1`
	echo "$nmbL"
	./Meteo_Project tmpP1.csv FmpP1.dat $nmbL p1 $type
	echo -e '
	set grid nopolar
	set grid xtics mxtics ytics noztics nomztics noztics nortics nomrtics nox2tics nomx2tics noy2tics nomy2tics nomcbtics
	set style data line
	set title "Graphique des pressions par stations"
	set xlabel "Stations"
	set ylabel "Pressions"
	Shadecolor = "#EECF83"

	set autoscale noextend
	set xrange [*;*]
	set xtics rotated by 90
	plot "FtmP1.dat" using 1:2:3 with filledcurves fc rgb Shadecolor notitle, "FmpP1.dat" using 1:4 with lines set linetype 2 lc rgb "sea-green" lw 2pt 7' | gnuplot --persist 2>/dev/null


elif [ "$p2" = "1" ]
then
	cut tmp0.csv -d';' -f2,7 | awk -F";" ' $1!="€" && $2!="€" {print $0} '  | tail -n+2 > tmpP2.csv
	nmbL=`wc -l tmpP2.csv | cut -d' ' -f1`
	./Meteo_Project tmpP2.csv FmpP2.dat $nmbL p2 $type


elif [ "$p3" = "1" ]
then
	cut tmp0.csv -d';' -f1,2,7 | awk -F";" ' $1!="€" && $2!="€" && $3!="€" {print $0} '  | tail -n+2 > tmpP3.csv
	nmbL=`wc -l tmpP3.csv | cut -d' ' -f1`
	./Meteo_Project tmpP3.csv FmpP3.dat $nmbL p3 $type


elif [ "$w" = "1" ]
then
	cut tmp0.csv -d';' -f1,4,5 | awk -F";" ' $1!="€" && $2!="€" && $3!="€" {print $0} '  | tail -n+2 > tmpW.csv
	nmbL=`wc -l tmpW.csv | cut -d' ' -f1`
	./Meteo_Project tmpW.csv FmpW.dat $nmbL w $type


elif [ "$m" = "1" ]
then
	cut tmp0.csv -d';' -f1,6 | awk -F";" ' $1!="€" && $2!="€" {print $0} '  | tail -n+2 > tmpM.csv
	nmbL=`wc -l tmpM.csv | cut -d' ' -f1`
	./Meteo_Project tmpM.csv FmpM.dat $nmbL m $type


elif [ "$h" = "1" ]
then
	cut tmp0.csv -d';' -f1,15 | awk -F";" ' $1!="€" && $2!="€" {print $0} '  | tail -n+2 > tmpH.csv
	nmbL=`wc -l tmpH.csv | cut -d' ' -f1`
	./Meteo_Project tmpH.csv FmpH.dat $nmbL h $type
	echo -e '
	set xlabel "Stations"
	set ylabel "Altitude"
	set title "altitude des stations"
	set view map
	set dgrid3d 100,100,2
	unset key
	unset surface
	set pm3d at b
	splot "FmpH.dat" ' | gnuplot --persist 2>/dev/null
fi
