#!/bin/bash

#Ce fichier va nous permettre de parser automatiquement les fichiers xml manquants
#et va aussi verifier que chaque fichier xml produit par le parser est valide selon la dtd
#et le schema que nous avons écrit. Il génère aussi les fichier xhtml à partir du
#fichier xsl.


#fonction de test de DTD
testDTD() {
    result=`xmllint --noout --dtdvalid src/gedcom.dtd "$1" 2>&1 >/dev/null`
    erreur=false
    if [ -n "$result" ]
    then
	echo "$result"
        exit 0
    else
	echo "[SUCCESS] ${1} avec la dtd gedcom.dtd"
    fi
}

#fonction de test de Schema
testSchema() {
    result=`xmllint --noout --schema src/gedcom.xsd "$1" 2>&1 >/dev/null`
    count=`echo "$result" | wc -w`

    if [ $count == 2 ]
    then
	echo "[SUCCESS] ${1} avec le schema gedcom.xsd"
    else
	echo "$result [FAIL] gedcom.xsd"
        exit 0
    fi
}


#Debut script
clear

#On regarde si le dossier html existe (pour la sortie de la commande xsltproc)
if [ ! -d "html" ]
then
    mkdir html #S'il n'existe pas, on le crée
fi

#On va regarder si le dossier bin existe pour la compilation du parseur
if [ ! -d "bin" ]
then
    mkdir bin #S'il n'existe pas, on va le créer
fi

if [ -z "$(ls -A bin 2>&1)" ]
then
    #On compile notre parseur s'il n'était pas déjà compilé
    echo "Compilation du parseur"
    cd bin
    scalac ../src/main/scala/parse.scala
    cd ..
fi


# Lorsque l'on ne passe aucun paramètre au script, on travaille sur les fichiers
# fournis pour le projet
if [ -z "$1" ]
then
    echo "[DEFAULT] On travaille sur les fichiers gedcom fournis pour le projet"
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
	    cd bin
	    scala parse ../${dataFolder}${fichier}.ged
	    cd ..
	fi

	#Dtd
        testDTD ${dataFolder}${fichier}.xml

	#Schemas
	testSchema ${dataFolder}${fichier}.xml

	#Xslt
	echo "Produit html/${fichier}.xhtml"
	xsltproc --output html/${fichier}.xhtml src/xml2html.xsl ${dataFolder}${fichier}.xml
    done
else
    #Sinon, on va parser le fichier gedcom passé en paramètre
    echo "[USER] Fichier gedcom fournis par l'utilisateur"
    echo "Parse du fichier ${1}"
    cd bin
    scala parse ../${1}
    cd ..

    
    #Dtd
    testDTD ${1%.ged}.xml

    #Schemas
    testSchema ${1%.ged}.xml

    #Xslt
    echo "Produit html/${1%.ged}.xhtml"
    xsltproc --output html/${1%.ged}.xhtml src/xml2html.xsl ${1%.ged}.xml
fi
