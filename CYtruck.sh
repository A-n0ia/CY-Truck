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

mkdir -p data
mkdir -p img
mkdir -p temp

FILE=$1
if [ "$1" = "-h" ]
then
	more -d help.txt
	exit 1
fi
cd data
if test -f "$FILE"; then
    nbF=1
else
	echo -e "Veuillez passez un nom de fichier existant en 1er argument !"
	exit 2
fi



for k in $@
do
	case $k in
			-h) if [ "$OPTARG" = "elp" ] || [ "$OPTARG" = "" ]
			then
				cd ..
				more -d help.txt
				exit 1
			fi
			;;
			-d1) d1=1
			;;
			-d2) d2=1
			;;
			-l) l=1	
			;;
			-s) s=1
			;;
	esac
done
if [ $# -lt 2 ]
then
	echo "Pas le bon nombre d'arguments :("
	echo "		${RED}N'hesitez pas a utilser le -h pour plus d'information${NC}"
	exit 1
fi

if [ "$d1" = 1 ]
then
	awk '{print $6}' FS=";" data.csv | awk '{print $1}' FS=";" |sort|uniq -c|sort -n -k1 -r | head > data_d1.dat
	
	echo -e '
		reset

		set boxwidth 1
		set grid ytics linestyle 0
		set style fill solid border -1
		set title "Graphique des conducteurs avec le plus de trajets"
		set xlabel "Nom"
		set ylabel "Distance"
		Shadecolor = "#EECF83"
		set autoscale noextend
		set xtics rotate by 45 right
		set xrange [*:*]
		set terminal png size 1000,750 enhanced font "Helvetica,20"
		set output "../img/Conducteur_nb_trajets.png"
		plot "data_d1.dat" using 4:5:xtic(2) with boxes lc rgb "blue" title "Nombre de trajet"' | gnuplot --persist 2>/dev/null
		eog ../img/Conducteur_nb_trajets.png &
fi


if [ "$d2" = "1" ]
then
	awk '{print $5,$6}' FS=";" OFS=";" data.csv |sort -k2 > ../temp/tempd2.csv
	awk '{n[$2]+=$1} END {for (x in n) {print x";"n[x]}}' FS=";" ../temp/tempd2.csv |sort -t";" -k2 -n -r | head > ../temp/tmp_d2.dat
	sed 's/;/ /g' ../temp/tmp_d2.dat > data_d2.dat
	echo -e '
		reset

		set boxwidth 1
		set grid ytics linestyle 0
		set style fill solid 1 border
		set title "Graphique des conducteurs avec le de km parcourue"
		set xlabel "Nom"
		set ylabel "Distance parcourue"
		Shadecolor = "#EECF83"
		set autoscale noextend
		set xtics rotate by 45 right
		set xrange [*:*]
		set terminal png size 1000,750 enhanced font "Helvetica,20"
		set output "../img/Conducteur_km_parcourues.png"
		plot "data_d2.dat" using 2:3:xstic(1) with boxes lc rgb "sea-green"  title "km parcourus"' | gnuplot --persist 2>/dev/null
		eog ../img/Conducteur_km_parcourues.png &
fi

if [ "$l" = "1" ]
then
	awk '{print $1,$5}' FS=";" OFS=";" data.csv |sort -k2 > ../temp/templ.csv
	awk '{n[$1]+=$2} END {for (x in n) {print x";"n[x]}}' FS=";" ../temp/templ.csv |sort -t";" -k2 -n -r | head > ../temp/tmpl.dat
	sed 's/;/ /g' ../temp/tmpl.dat > data_l.dat
	echo -e '
		reset

		set boxwidth 1
		set grid ytics linestyle 0
		set style fill solid 1 border
		set title "Graphique des trajets les plus longs"
		set xlabel "Distance"
		set ylabel "ID trajet"
		Shadecolor = "#EECF83"
		set autoscale noextend
		set xtics rotate by 45 right
		set xrange [*:*]
		set terminal png size 1000,750 enhanced font "Helvetica,20"
		set output "../img/Long_trajets.png"
		plot "data_l.dat" using 1:2:xtic(3) with boxes lc rgb "#FF0000" title "Longueur des trajets en km"' | gnuplot --persist 2>/dev/null
		eog ../img/Long_trajets.png &
fi

if [ "$s" = 1 ]
then
	echo -e "Sorry, work in progress :("
fi

cd ..

rm -f temp/tempd2.csv temp/templ.csv temp/tmp_d2.dat temp/tmpl.dat
