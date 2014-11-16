import scala.io.Source
import scala.util.matching.Regex
import scala.collection.mutable.Stack


/**
 * @author clement
 */
object parse extends App{
  
  var xml_file = ""
  var pat_word = """\S+""".r
  var pat_s_close ="""FAM(C|S)|SEX|HUSB|WIFE|CHIL""".r //paterne des balises auto-fermantes

  //retourne le nombre de tabulations demandé :
  def addTab(tab:Int) = {
    var s = ""
    for(i <- tab to 0 by -1)
      s+="\t"
    s
  }
  
  //détermine si l'expression fait partis de la regex
  def r (regex:Regex,exp:String) =
    regex.findFirstIn(exp).isDefined

  //détermine si l'entité est auto-fermante
  def isClosed(entity:String) =//TODO : modifier en isSelfClose
    r(pat_s_close,entity)
  
    
  def gedcomToXml (f:String): Unit = {
    var pile = new Stack[(Int,String)]
    pile.push((-1,"gedcom"))
    
    var res = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<gedcom>\n"
    
    //0 - lire ligne à ligne le fichier source :
    for( line <- Source.fromFile("complet.ged").getLines()){
      println(line)//afficher la ligne extaite 
      var it = pat_word.findAllIn(line)//ittérator sur la ligne
      var s_close = false //self close : détermine si la balise est auto fermante
      
      if(it.hasNext){//ligne non vide
       try{
          //1 - recherche du niveau (num) :
          val n = it.next
          var num = n.toInt
        
          //2 - recheche du nom de l'entité :
          var entity = it.next//read entity ce qui est lu
          var w_entity = entity//write entity ce qui sera vraiment écris

          
          //3 - on détecte le type d'entité (but modifier leurs balise): //TODO : voir si c'est possible d'utiliser un match case
          //3.1 entité identifiant (self close):
          if(r("""@.\d+@""".r,entity)){       
              val id = """.\d+""".r.findFirstIn(entity).get
              entity = it.next
              w_entity=""
              w_entity+= entity+" id="+id
          }else
            
          //3.2 entité FAMC FAMS (self close):
          if(r("""FAM(C|S)""".r,entity)){
            val id_brut = it.next
            val id = """.\d+""".r.findFirstIn(id_brut).get 
            w_entity+=" id="+id
          }else
          
          //3.3 entité SEX (self close) (parti pris : on suppose qu'il n'y a pas de 3eme sexe)
          if(r("""SEX""".r,entity)){
            val sex = it.next
            w_entity+=" type="+sex
          }else
          
          //3.4 type de famille (self close)
          if(r("""HUSB|WIFE|CHIL""".r,entity)){ //XXX voir si peut être réuni avec FAMC et FAMS
            val id_brut = it.next
            val id = """.\d+""".r.findFirstIn(id_brut).get
             w_entity+=" id="+id
          }else
            
          //3.5 fin de document
          if(r("""TRLR""".r,entity)){//XXX : problème éventuel la boucle ce termine exactement quand la balise TRLR arrive vérifier si avec des espaces en dessous ça casse pas le document xml
            num = -1
            w_entity = ""
          }

          //TODO : detection adresse internet FILE
          
          
          
          //4 - fermer la balise celon le contenu de la pile : XXX : donné plus d'explication
          num match {

            //4.2 égale au num dans la pile
            case n if (n == pile.head._1)  =>
              if(!isClosed(pile.head._2))
                res+="</"+pile.head._2+">"//fermeture balise
              pile.pop()

            //4.3 inférieur au num dans la pile
            case n if (n < pile.head._1) =>                        
              while(!(pile.head._1 < num) ){
                if(!isClosed(pile.head._2))//verifier que nous ne somme pas une balise auto-fermante
                  res+="\n"+addTab(pile.head._1)+"</"+pile.head._2+">"//fermeture balise
                pile.pop()
              }
              
            case _ => true //TODO trouver comment ne rien faire  (si on retire cette ligne ça bug)

          }
          
          //5 ouvrir la balise celon le contenu
          pile.push((num,entity))
          if(isClosed(entity)){
            res+="\n"+addTab(num)+"<"+w_entity+" />"//TODO possible d'utiliser StringContex à la place de ça qui est lourd
          }else{
            res+="\n"+addTab(num)+"<"+w_entity+">"//ouverture balise
          }
          
          
          if(!isClosed(entity)){
            //6 on complète avec le reste de ligne
            for(x <-it){
              res+=" "+x
            }
          }
      
        }catch {
          case e:Exception => println("problème le format gedcom n'est pas respecté")
        }
      }
    }
    
    println("le contenu de res =====\n"+res)///XXX a modifier pour que le résultat soit dans un fichier
  }

  
  gedcomToXml("")
}


/*
//petit teste (mis de coté)

implicit class Regex(sc: StringContext) {
  def r = new util.matching.Regex(sc.parts.mkString, sc.parts.tail.map(_ => "x"): _*)
}

for(ent <- pat_word.findAllIn(line)){
  ent match{
    case r"\d+"  => println(ent+"--est un nombre")
    case r"[A-Z]+" => println(ent+"--est un mot gedcom")
    case r"\w+" => println(ent+"--est un mot non gedcom")
    //case r"@.\d+@" => println(ent+" est un id")
    case r"@F\d+@" => println(ent+" est un id Fam")
    case r"@I\d+@" => println(ent+" est un id Ind")
    case _=> println(ent+"--n'est pas pris en compte")
  }
}

*/