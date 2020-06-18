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



# Problema 1: ---------------------------------------------------------------

executionSummaryData=(´find $searchDir -name '*.txt' -print | sort | grep executionSummary | grep -v '._'´)

execSummaryOutFile="metrics.txt"

tmpTimeSimulation="TiempoSimulado.txt"
tmpUsedMem="MemoriaUsada.txt"

rm -f $execSummaryOutFile
rm -f $tmpTimeSimulation
rm -f $tmpUsedMem

printf "tsimTotal:promedio:min:max \n memUsada:promedio:min:max \n" >> $execSummaryOutFile

for i in ${executionSummaryData[*]};
do
	tsimTotal=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumaTiempo=0}{sumaTiempo=$6+$7+$8} END{print sumaTiempo}')
	printf $tsimTotal >> $tmpTimeSimulation
	TotalMemUsed=$(cat $i | tail -n+2 | cut -d ':' -f 10)
	printf $TotalMemUsed >> $tmpUsedMem
done

timeSimStats=$(cat $tmpTimeSimulation | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1}\
	if($1>max){max=$1};\
	total+=$1; count+=1;\
	} \
	END { print total, total/count, min, max}')

memUsedStats=$(cat $tmpUsedMem | awk 'BEGIN{ min=2**63-q; max=0}{ if($1<min){min=$1};\
	if($1>max){max=$1};\
	total+=$1; count+=1;\
	} \
	END { print total, total/count, min, max}')


printf "%i:%i:%i:%i \n %i:%i:%i:%i\n" $timeSimStats $memUsedStats >> $execSummaryOutFile
rm -f $tmpTimeSimulation $tmpUsedMem

# Problema 2: ---------------------------------------------------------------

summaryData=(´find $searchDir -name '*.txt' -print | sort | grep Summary | grep -v '._'´)

summaryOutFile="evacuation.txt"

tmpAll="tmpAll.txt"
tmpResidents="tmpResidents.txt"
tmpVisitType1="tmpVisitType1.txt"

rm -f $summaryOutFile
rm -f $tmpAll
rm -f $tmpResidents
rm -f $tmpVisitsType1

for i in ${summaryData[*]};
do
	alls=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumPeople=0}{sumPeople+=$8} END{print sumResidents}')
	printf $alls >> $tmpAll
	residents=$(cat $i | tail -n+2 |awk -F ':' 'BEGIN{sumResidents=0}; {if($3==0){sumResidents+=$8}} END{print sumResidents}')
	printf $residents >> $tmpResidents
	visitsType1=(cat $i | tail -n+2 |awk -F ':' 'BEGIN{sumVisit=0}; {if($3==1){sumVisit+=$8}} END{print sumVisit}')
	printf $visitsType1 >> $tmpVisitsType1
done

allStats=$(cat $tmpAll | awk 'BEGIN{ min=2**63-1; max=0}{ if($1>min){min=$1};\
	if($1>max){max=$1};\
	total+=$1; count+=1;\
	} \
	END { print total, total/count, min, max}')

residentStats=$(cat $tmpResidents | awk 'BEGIN{ min=2**63-1; max=0}{ if($1>min){min=$1};\
	if($1>max){max=$1};\
	total+=$1; count+=1;\
	} \
	END { print total, total/count, min, max}')

visitsType1Stats=$(cat $tmpVisitsType1 | awk 'BEGIN{ min=2**63-1; max=0}{ if($1>min){min=$1};\
	if($1>max){max=$1};\
	total+=$1; count+=1;\
	} \
	END { print total, total/count, min, max}')

printf "alls:promedio:min:max \n"  >> $summaryOutFile
echo $allStats >> $summaryOutFile
printf "residents:promedio:min:max \n" >> $summaryOutFile
echo $residentStats >> $summaryOutFile
printf "visitors1:promedio:min:max \n"  >> $summaryOutFile
echo $visitType1Stats >> $summaryOutFile

rm -f $tmpAll
rm -f $tmpResidents
rm -f $tmpVisitsType1

# Problema 3: ---------------------------------------------------------------

usePhoneData=(´find $searchDir -name '*.txt' -print | sort | grep usePhone | grep -v '._'´)

usePhoneOutFile="usePhone-stats.txt"

tmpUsePhone="tmpUsePhone.txt"

rm -f $usePhoneOutFile
rm -f $tmpUsePhone

for i in ${usePhoneData[*]};
do
	useTime=´(`cat $i | tail -n+3 | cut -d ':' -f 3`)
	for j in ${useTime[*]}
	do
		printf "%d:" $i >> $tmpUsePhone
	done
	printf "\n" >> $tmpUsePhone
done

usePhoneStats=$(cat $tmpUsePhone | cut -d ':' -f $i | awk 'BEGIN{min02**63-1; max=0}\
	{if($1<min){min=$1}; if($1>max){max=$1}; total+=$1; count+=1;}\
	END {print total/count, min, max}')

rm -f $tmpUsePhone

printf "timestamp:promedio:min:max \n"  >> $usePhoneOutFile
echo  $usePhoneStats >> $usePhonOutPhile
