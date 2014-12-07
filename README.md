projet réalisé par Clément Charasson et Alain Dias

1. prérequis
	* avoir la JVM 1.6 ou plus
	* installer scala
	* installer sbt

2. comment utiliser le code (actuellement ça ne marche pas comme ça)
	* se positionner dans le répertoire /src

  ~~~~sh
	scala parse [chemin du fichier.ged]
  ~~~

2. comment le code marche réellement actuellement
  * se positionner dans le répertoire racine
  * faire sbt
  * faire run data/fichier.ged


3. Script sh pour automatiser les validation et transformations xslt
  * Se positionner dans le répertoire racine du projet
  * Rendre le script projet.sh executable (e.g chmod u+x projet.sh)
  * Lancer le script ./projet.sh
  * Le script s'arrete au premier fichier non valide, lance le parse s'il ne 
  trouve pas le fichier xml et genère le html produit par application de la feuille
  de style xslt
