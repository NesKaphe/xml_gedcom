projet réalisé par Clément Charasson et Alain Dias

1. prérequis
	* avoir la JVM 1.6 ou plus
	* installer scala

2. comment utiliser le code (actuellement ça ne marche pas comme ça)
	* se positionner dans le répertoire /src

  ~~~~sh
	scala parse [chemin du fichier.ged]
  ~~~

2. comment le code marche réellement actuellement
  * se positionner dans le répertoire racine
  * faire sbt
  * faire run data/fichier.ged


3. Valider selon la DTD gedcom.dtd
  * Se positionner dans le répertoire racine
  * Rendre le script validateDtd.sh executable (chmod u+x)
  * Lancer le script ./validateDtd.sh
  * Le script s'arrete au premier fichier non valide et lance le parse s'il ne 
  trouve pas le fichier xml
