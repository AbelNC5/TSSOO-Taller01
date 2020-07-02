#!/bin/bash

usage_manual(){
        printf "\nUso $0 -d <directorio> [-h]\n"
        printf "\t-d: directorio donde estan los datos.\n"
        printf "\t-h: muestra este mensaje y termina.\n"
        exit 1
}

while getopts "d:h" opcion; do
        case "$opcion" in


                d)
                        directorio=$OPTARG
                        ;;

                h)
                        usage_manual
                        ;;
                *)
                        echo "Función incorrecta"
                        usage_manual
                        ;;
        esac
done


# La variable $# es equivalente a argc
if [ $# != 1 ]; then
	echo "Uso: $0 <directorio busqueda>"
	exit
fi


searchDir=$1

# Verificar que searchDir efectivamente es un elemento existente
if [ ! -e $searchDir ]; then
	echo "Directorio $1 no existe"
	exit
fi

printf "Directorio busqueda: %s\n" $1



# Problema 1: ---------------------------------------------------------------

executionSummaryData=(`find $searchDir -name '*.txt' -print | sort | grep executionSummary | grep -v '._'`)

execSummaryOutFile="metrics.txt"

tmpTimeSimulation="TiempoSimulado.txt"
tmpUsedMem="MemoriaUsada.txt"

rm -f $execSummaryOutFile
rm -f $tmpTimeSimulation
rm -f $tmpUsedMem

for i in ${executionSummaryData[*]};
do
	tsimTotal=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumTime=0}{sumTime=$6+$7+$8} END{print sumTime}')
	printf "$tsimTotal \n" >> $tmpTimeSimulation
	timeSimStats=$(cat $tmpTimeSimulation | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpTimeSimulation<min){min=$tmpTimeSimulation};\
		if($tmpTimeSimulation>max){max=$tmpTimeSimulation};\
		total+=$tmpTimeSimulation; count+=1;\
		} \
		END { print total, total/count, min, max}')


	totalMemUsed=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumMem=0}{sumMem=$9+$10} END{print sumMem}')
	printf "$totalMemUsed \n" >> $tmpUsedMem
	memUsedStats=$(cat $tmpUsedMem | awk 'BEGIN{ min=2**63-q; max=0}{ if($tmpUsedMem<min){min=$tmpUsedMem};\
		if($tmpUsedMem>max){max=$tmpUsedMem};\
		total+=$tmpUsedMem; count+=1;\
		} \
		END { print total, total/count, min, max}')
done

printf "tsimTotal:prom:min:max\n" >> $execSummaryOutFile
printf "%i : %i : %i : %i \n" $timeSimStats >> $execSummaryOutFile
printf "memUsed:prom:min:max\n" >> $execSummaryOutFile
printf "%i : %.2f : %i: %i \n" $memUsedStats >> $execSummaryOutFile

rm -f $tmpTimeSimulation
rm -f $tmpUsedMem

# Problema 2: ---------------------------------------------------------------

summaryData=(`find $searchDir -name '*.txt' -print | sort | grep summary | grep -v '._'`)

summaryOutFile="evacuation.txt"

tmpAll="tmpAll.txt"
tmpResidents="tmpResidents.txt"
tmpVisitType1="tmpVisitType1.txt"

rm -f $summaryOutFile
rm -f $tmpAll
rm -f $tmpResidents
rm -f $tmpVisitType1

for i in ${summaryData[*]};
do
	alls=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumPeople=0}{sumPeople+=$8} END{print sumPeople}')
	echo $alls >> $tmpAll
	residents=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumResidents=0}; {if($3==0){sumResidents+=$8}} END{print sumResidents}')
	echo $residents >> $tmpResidents
	visitType1=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumVisit=0}; {if($3==1){sumVisit+=$8}} END{print sumVisit}')
	echo $visitType1 >> $tmpVisitType1
done

allStats=$(cat $tmpAll | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
	if($1>max){max=$1};\
	total+=$1; count+=1;\
	} \
	END { print total, total/count, min, max}')

residentStats=$(cat $tmpResidents | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
	if($1>max){max=$1};\
	total+=$1; count+=1;\
	} \
	END { print total, total/count, min, max}')

visitType1Stats=$(cat $tmpVisitType1 | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
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

rm -f $tmpAll $tmpResidents $tmpVisitType1

# Problema 3: ---------------------------------------------------------------

usePhoneData=(`find $searchDir -name '*.txt' -print | sort | grep usePhone | grep -v '._'`)

usePhoneOutFile="usePhone-stats.txt"

tmpUsePhone="tmpUsePhone.txt"
tmpStampPhone="tmpStampPhone.txt"

rm -f $usePhoneOutFile
rm -f $tmpUsePhone
rm -f $tmpStampPhone

printf "timestamp:prom:min:max\n" >> $usePhoneOutFile

for i in ${usePhoneData[*]};
do
	timeStampPhone=(`cat $i | tail -n+3 | cut -d ':' -f 2`)
	usePhone=(`cat $i | tail -n+3 | cut -d ':' -f 3`)

	for j in ${usePhone[*]};
	do
		printf "%d:\n" $j >> $tmpUsePhone
		usePhoneStats=$(cat $tmpUsePhone | cut -d ':' -f 1 | awk 'BEGIN{ min=2**63-1; max=0}{if($j<min){min=$j}};\
			{if($j>max){max=$j}};\
			{total+=$j; count+=1};\
			END { print total/count, min, max}')
	done

	for j in ${timeStampPhone[*]};
	do
		printf "%d:\n" $j >> $tmpStampPhone
		timeStampStats=$(cat $tmpStampPhone | awk -F ':' 'BEGIN{ totalTime; countTime}{totalTime+=$1; countTime+=1 };\
		END {print totalTime/countTime}')
	done

	printf "%i : %.2f : %i : %i \n" $timeStampPhone $usePhone >> $usePhoneOutFile
	rm -f $tmpUsePhone
	rm -f $tmpStampPhone
done

rm -f $tmpUsePhone
rm -f $tmpStampPhone
