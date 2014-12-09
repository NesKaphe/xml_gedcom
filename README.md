projet xml réalisé par Clément Charasson et Alain Dias

1. prérequis
	* installer java ; la JVM 1.6 ou plus
	* installer scala
	* installer xsltproc et xmllint

2. Script sh pour automatiser qui compile et génère tout les fichiers

Ce fichier va nous permettre de parser automatiquement les fichiers xml
manquants et va aussi verifier que chaque fichier xml produit par le parser est
valide selon la dtd et le schema que nous avons écrit. Il génère aussi les
fichiers xhtml à partir du fichier xsl.


  * Se positionner dans le répertoire racine du projet
  * Rendre le script projet.sh executable (e.g chmod u+x projet.sh)

  2.1.fichiers fournis

    * Le script s'arrete au premier fichier non valide, lance le parse s'il ne 
    trouve pas le fichier xml et genère le html produit par application de la
    feuille de style xslt
    * Lancer le script ./projet.sh pour travailler sur les fichiers fournis
    * Note : Il est également possible d'executer make pour faire appel à cette option

  2.2.fichier choisi par l'utilisateur

    * Il est possible de donner un fichier gedcom en paramètre du script,
    le script va se charger de lancer le parse du fichier puis va lancer tous
    les tests de validité et produire le fichier xhtml dans le dossier html
    * Lancer le script ./projet.sh [chemin fichier.ged] pour travailler sur un
    fichier spécifique

  2.3.Nettoyer les fichiers produits par le script sh

    * Le Makefile nous permet de supprimer tous fichiers produit. Grace a clean,
    nous tous fichiers html et xml produits sont supprimés. Avec mrproper, l'executable
    du parseur est lui aussi supprimé.
 
===============================================================================

Les explications qui vont suivrent sont utile dans le cas ou l'on veux tout
tester 1 par 1:


3. Comment parser un fichier spécifique 

   3.1.(Se référer au 2.2)

4. Comment compiler et parser sans sbt?
    * se positionner dans le répertoire racine
    * faire :     cd src/main/scala
    * puis faire : 
          scalac parse
          scala parse [fichier.ged]
    * le fichier.xml sera généré dans le dossier où est enregistré le .ged

5. Comment vérifier que la dtd sur un fichier xml?
  * se positionner dans src
  * faire:  xmllint --noout --dtdvalid gedcom.dtd [fichier.xml]

6. Comment vérifier le shémas sur un fichier xml?
  * se positionner dans src
  * faire:  xmllint --noout --schema gedcom.xsd [fichier.xml]

7. Comment générer les fichier.xhtml?
  * se positionner dans src
  * faire:  xsltproc xml2html.xsl [fichier.xml]

