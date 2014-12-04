#!/bin/bash

#Ce fichier va nous permettre de parser automatiquement les fichiers xml manquants
#et va aussi verifier que chaque fichier xml produit par le parser est valide selon la dtd
#et le schema que nous avons écrit


clear

fichiers[0]="data/begood"
fichiers[1]="data/doe"
fichiers[2]="data/complet"
fichiers[3]="data/french"
fichiers[4]="data/royal"


for fichier in ${fichiers[*]}
do
    if [ ! -f "${fichier}.xml" ]
    then
	echo "${fichier}.xml non trouvé. Parse : ${fichier}.xml"
	sbt "run-main parse ${fichier}.ged" >/dev/null
    fi

    #Dtd
    result=`xmllint --noout --dtdvalid src/gedcom.dtd "$fichier".xml 2>&1 >/dev/null`
    erreur=false
    if [ -n "$result" ]
    then
	echo "$result"
        erreur=true
    else
	echo "[SUCCESS] ${fichier}.xml avec la dtd gedcom.dtd"
    fi

    #Schemas
    result=`xmllint --noout --schema src/gedcom.xsd "$fichier".xml 2>&1 >/dev/null`
    count=`echo "$result" | wc -w`

    if [ $count == 2 ]
    then
	echo "[SUCCESS] ${fichier}.xml avec le schema gedcom.xsd"
    else
	echo "$result [FAIL] gedcom.xsd"
	erreur=true
    fi

    if [ "$erreur" = true ]
    then
	exit 0
    fi

    #xsl
    ##TODO: inserer ici la commande pour générer le html avec xmlproc
done

