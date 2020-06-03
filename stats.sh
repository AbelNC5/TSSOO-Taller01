#!/bin/bash

# La variable $# es equivalente a argc
if [ $# != 1 ]; then
	echo "Uso: $0 <directorio busqueda>"
	exit
fi


searchDir=$1

# Verificar que searchDir efectivamente es un elemento existente
if [ ! -e $searchDir ] then
	echo "Elemento $1 no existe"
	exit
fi

#Verificar que el elemento es realmente un directorio
if [ ! -d $searchDir ]; then 
	echo "$1 Es un elemento pero no un Directorio"
	exit
fi

printf "Directorio busqueda: %$\n" $1


#Problema 1: ------------------------------------------------------------

