1.Le parseur

1.1.Choix du langage Scala

Le parser est fait en scala. Plusieurs raisons nous ont fait choisir ce
langage. La première étant qu'il était nouveau pour nous et le meilleur moyen
d'apprendre c'est de pratiquer. Plus sérieusement il y a des raison technique
qui font que scala nous intéresse. Il est possible d'utiliser de façon
transpante java dans le langage scala. On peux donc utiliser les librairies de
parser XML de java dans scala. Nous n'utilisons pas celà car celà reviendrait
tout simplement à faire du java et non du scala.
Le langage Scala a un system d'expression régulières simple et puissant. Il a
aussi des facilités d'utilisation avec le xml, on peux par exemple directement 
écrire du xml dans le langage. Cette avantage ne sera malheureusement mis à 
profit car nous avons découvert que les balises étant non modifiable.
Dernière chose scala à l'avantage d'être concis et donc simple à
relire.

1.2.Description de l'algoritme


L'algorithme est relativement simple il parcours de façon linéaire le fichier.
Le langage gedcom possède 3 informations différentes que nous
traitons, dans le même ordre à chaques lignes (sauf pour les balises
qui possèdent des identifiants avec @).


1.2.1.Traitement de l'information

Dans le cas générale les informations sont gérés de la façon suivante :

La première information (premier mot) est un chiffre. Ce chiffre nous l'utilisons
comme niveau de notre balise. C'est à dire qu'un chiffre élevé correspond à la
balise parente d'une balise qui possède un chiffre plus faible et qui la suit.

La deuxième information (deuxième mot) correspond au nom l'élément xml.
A chaque élément croisé nous empilons son nom et son niveau dans une pile.

La troisième information (tout les mots qui suivent) c'est l'information 
que doit contenir notre balise. Il y a 2 types de remplissages. Soit on laisse
l'information "brute" dans le contenu de notre élément ; C'est le cas le plus
générale. Soit on rajoute un attribut à la balise qui contient cette
information. Dans ce dernier cas la plus part du temps on fait une balise auto
fermante et accompagné d'un traitement spécifique à l'élément dans le code.

Dans le cas des identifiants gedcom l'ordre des informations est légèrement
différentes. Et un traitement spécifique est fait.

1.2.2.La fermeture des balises

A chaque nouvelles lignes nous regardons si le niveau de la ligne est supérieur 
au niveau de la ligne précédente. Autrement dit nous regardons le niveau de la
tête de pile. Si ce niveau est inférieur à notre niveau actuelle (chiffre plus
faible), nous dépilons et créons les balises fermantes. Nous faisons cela 
jusqu'à atteindre un niveau qui nous est supérieur.

1.2.3.Partis pris dans le code

Nous ne nous sommes pas attaché à vérifier que le fichier gedcom était valide.
Nous supposons à priorie les informations respectent la norme gedcom. Ce 
choix est justifiable.
Par exemple dans le cas de french.ged il semble que la balise misc n'est pas 
proposée dans la spécification gedcom, mais nous la traitons comme tel.
C'est la dtd et le schémas qui ce charge de vérifier le bon remplissage de
notre fichier gedcom.



2.la dtd

Afin de réaliser la DTD, nous avons dans un premier temps analysé chaque fichiers
xml produit par notre parseur. Nous avons procédé de manière incrémentale jusqu'a
ce que chacun des fichiers soit valide.
De plus, la norme gedcom n'impose aucun ordre au niveau des balises. Dans notre
cas, nous imposons un ordre dans lequel les balises doivent apparaitre. En effet,
sans cet ordre, il serait impossible de limiter à la fois l'apparition unique d'une
balise et à la fois une répétition multiple d'une autre balise et ce dans n'importe
quel ordre. Ce choix, à été fait afin de ne pas obtenir une dtd trop permissive.



3.le shémas

Pour les meme raison que la dtd, il nous avons décidé d'imposer un ordre au niveau de l'apparition
des balises. Cependant, afin de permettre un ordre non defini, nous avions deux options
"xsd:all" et "xsd:choice". Aucune de ces deux options ne nous ont permis d'obtenir le resultat
souhaité. En effet, xsd:all ne nous permet l'apparition d'au plus qu'une 
fois un element. Or, dans l'element indi, il doit etre possible d'avoir
plusieurs "fams". Avec xsd:choice, nous perdons la limitation que l'element
"name" ne doit apparaitre qu'une fois.

Concernant la construction, nous avons remarqué que certain éléments étaient
construits de manière similaire. Afin de ne pas dupliquer les definitions 
similaires, nous avons définis plusieurs types complexes nommés.
Par exemple, les elements contenant l'attribut ref faisant reference à un 
xsd:ID sont regroupés dans le type "referenceId"

Le schéma nous a permis d'obtenir une meilleure précision concernant le 
contenu simple de chaque élements là où nous n'avons que #PCDATA dans 
une dtd. De plus, nous pouvons mieux définir les balises ayant un contenu mixte.
En effet, contrairement à la dtd, nous pouvons limiter le nombre d'apparitions 
de chaque elements. Dans la dtd, nous devions spécifier une répétition de choix 
entre différents elements et du contenu #PCDATA. 





4.le convertisseur xslt

Pour décrire ce que nous avons fait, nous allons passer d'un point vu à
l'autre, entre le ficher xslt et le résultat visuel dans un navigateur web.

Nous utilisons deux indexes. Un sur les identifiants des individus et un sur
les identifiants des familles. C'est grace à cette index que nous faisons nos
liens internes (balises <a>) dans le fichier html. Concrètement quand on clique
sur le nom d'un individus ou d'une famille nimporte où dans la page web on
affiche les informations dans la partie centrale.

C'est aussi à partir de l'indexe des individus qu'est généré la liste des
"prénoms" des individus sur le coté gauche.

Dans la partie centrale il y a un découpage en 2 parties en premier les
individus et en deuxièmes les familles.

La première information sur l'individus est sont "dénommage", à savoir le titre
entre crochet, suivit du prénom (ou alias), suivit du nom.
Étant difficile de voir si l'information sur le nom est renseignée ou non, nous
faisons une coloration différente pour le nom. Dans le cas ou le prénom n'est
pas renseigné nous mettons un point d'interrogation suivit du nom. Dans le cas
ou il n'y a nom n'y prénom nous marquons "unnamed". Dans le fichier xslt ce
traitement est éffectué par un xsl:choice.

Les informations sur l'invidus sont affichés si elles son présentes. Dans le
cas contraire on n'affiche pas un champ vide par soucis de lisibilité de
l'information. Nous utilisons xsl:if pour faire celà.

Certain bout de code étant identique d'une balise à l'autre nous faisons
appel à certaines règles via des xsl:call-template. Par exemple il y a souvent
la suite d'informations date, place et qualité de la donné dans des balises
différentes.

Les familles ont 3 façons d'être affichées c'est pourquoi il y a 3 modes sur
les familles. Il a 2 affichages dans les individus. Pour famc on affiche father
mother et brothers/sisters. Dans les fams on affiche husband, wife et childs.
Les informations sur les prénoms sont récupérés via l'utilisations des indexes.
Le troisième affichage est destiné aux balises <fam> qui sont afficher dans la
partie famille du fichier.
