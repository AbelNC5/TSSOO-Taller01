#!/bin/bash

# La variable $# es equivalente a argc
if [ $# != 1 ]; then
	echo "Uso: $0 <directorio busqueda>"
	exit
fi


searchDir=$1

# Verificar que searchDir efectivamente es un elemento existente
if [ ! -e $searchDir ]; then
	echo "Elemento $1 no existe"
	exit
fi

# Verificar que el elemento es realmente un directorio
if [ ! -d $searchDir ]; then 
	echo "$1 Existe pero no es un Directorio"
	exit
fi

printf "Directorio busqueda: %s\n" $1



# Problema 1: -----------------------------------------------------------------

executionSummary=(´find $searchDir -name '*.txt' -print | sort | grep executionSummary | grep -v '._'´)

execSummaryOutFile="metrics.txt"
tmpTimeSimulation="TiempoSimulado.txt"
tmpUsedMem="MemoriaUsada.txt"

rm -f $execSummaryOutFile
rm -f $tmpTimeSimulation
rm -f $tmpUsedMem

printf "tsimTotal:promedio:min:max \n memUsada:promedio:min:max \n" >> $execSummaryOutFile

for i in ${executionSummary[*]};
do
	printf "> %s\n" $i
#	tsimTotal=$(cat $i )
done

printf "%i:%i:%i:%i\n%i:%.2f:%i:%i\n" $timeSimStats $memUsedStats >> $execSummaryOutFile

# Problema 2: -----------------------------------------------------------------

#Summary=(´find $searchDir -name '*.txt' -print | sort | grep Summary | grep -v '._'´)
#summaryOutFile="evacuation.txt"
#tmpFileP2="tmpFileP2.txt"
#rm -f $summaryOutFile
#rm -f $tmpFileP2
#printf "alls:promedio:min:max \n"  >> $summaryOutFile

# Problema 3: -----------------------------------------------------------------

#usePhone=(´find $searchDir -name '*.txt' -print | sort | grep usePhone | grep -v '._'´)

#usePhonOutFile="usePhone-stats.txt"
#tmpFileP3="tmpFileP3.txt"

#rm -f $usePhonOutFile
#rm -f $tmpFileP3

#printf "timestamp:promedio:min:max \n"  >> $usePhoneOutFile
