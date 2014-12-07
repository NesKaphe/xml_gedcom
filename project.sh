#!/bin/bash

#Ce fichier va nous permettre de parser automatiquement les fichiers xml manquants
#et va aussi verifier que chaque fichier xml produit par le parser est valide selon la dtd
#et le schema que nous avons écrit. Il génère aussi les fichier xhtml à partir du
#fichier xsl.


clear

#On regarde si le dossier html existe (pour la sortie de la commande xsltproc)
if [ ! -d "html" ]
then
    mkdir html #S'il n'existe pas, on le crée
else
    rm html/* #Sinon, on vide son contenu pour regénérer les fichiers html
fi

dataFolder="data/"

fichiers[0]="begood"
fichiers[1]="doe"
fichiers[2]="complet"
fichiers[3]="french"
fichiers[4]="royal"

for fichier in ${fichiers[*]}
do
    if [ ! -f "${dataFolder}${fichier}.xml" ]
    then
	echo "${fichier}.xml non trouvé. Parse : ${fichier}.xml"
	sbt "run-main parse ${dataFolder}${fichier}.ged" >/dev/null
    fi

    #Dtd
    result=`xmllint --noout --dtdvalid src/gedcom.dtd "$dataFolder""$fichier".xml 2>&1 >/dev/null`
    erreur=false
    if [ -n "$result" ]
    then
	echo "$result"
        erreur=true
    else
	echo "[SUCCESS] ${fichier}.xml avec la dtd gedcom.dtd"
    fi

    #Schemas
    result=`xmllint --noout --schema src/gedcom.xsd "$dataFolder""$fichier".xml 2>&1 >/dev/null`
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

    #Xslt
    xsltproc --output html/${fichier}.xhtml src/xml2html.xsl ${dataFolder}${fichier}.xml
done

