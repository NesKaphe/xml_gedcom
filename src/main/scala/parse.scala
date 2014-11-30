import scala.io.Source
import scala.util.matching.Regex
import scala.collection.mutable.Stack
import java.io.PrintWriter

/**
 * @author clement
 */
object parse {
  
  var xml_file = ""
  var pat_spec = """<|>|\&|'|\"""".r//paterne caractère spéciaux
  var pat_word = """\S+""".r//paterne sur les caractères visibles
  var pat_s_close ="""FAM(C|S)|SEX|HUSB|WIFE|CHIL|NAME""".toLowerCase.r //paterne des balises auto-fermantes
  var res = ""

  
  //convertis tout les caractères spéciaux pour les adapter au xml
  def convertSpecial(s:String):String={
    var st = s
    if(pat_spec.findFirstIn(s).isEmpty) return s
    
    st = """\&""".r replaceAllIn(st, "&amp;")
    st = """<""".r replaceAllIn(st, "&lt;")
    st = """>""".r replaceAllIn(st, "&gt;")
    st = """\"""".r replaceAllIn(st, "&quot;")
    st = """\'""".r replaceAllIn(st, "&apos;")
    
    return st
  }
  
  //vide le contenu de l'itérator de string et retourne la chaine
  def restOfLine(it:Iterator[String],separator:String):String={
    var str = ""
    for(s<-it){
      str+=s
      if(it.hasNext)
        str+=separator
    }
    return str
  }
  
  //Determine si le chemin du fichier existe
  def exists(file:String) : Boolean = {
    try {
      Source.fromFile(file)
    }catch {
      case e:java.io.FileNotFoundException => 
	{
	  println("Le fichier "+file+" n'existe pas")
	  return false
	}
    }
    return true
  }

  //Prend un nom fichier et remplace son extension par .xml (ou l'ajoute si le fichier n'avait pas d'extensions)
  def replaceExtension(filename:String) = {
    def addXmlAt(index: Int) : String = (
      if (index >= 0) filename substring (0, index) 
      else filename
    ) + ".xml"

    addXmlAt(filename lastIndexOf '.')
  }


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
    var pile = new Stack[(Int,String)]//int = niveau , sgring = l'entité
    
    pile.push((-1,"gedcom"))
    var prev_level = -1//niveau précédent
    
    res = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<gedcom>\n"
    
    //0 - lire ligne à ligne le fichier source :
    for( line <- Source.fromFile(f).getLines()){
      //println(line)//afficher la ligne extaite 
      var it = pat_word.findAllIn(line)//ittérator sur la ligne
      var s_close = false //self close : détermine si la balise est auto fermante
      
      if(it.hasNext){//ligne non vide
	      try{
          //1 - recherche du niveau (num) :
          val n = it.next
          var num = n.toInt
          
          //2 - recheche du nom de l'entité :
          var entity = it.next.toLowerCase//read entity ce qui est lu
          var w_entity = entity//write entity ce qui sera vraiment écris

          
          //3 - on détecte le type d'entité (but modifier leurs balise): //TODO : voir si c'est possible d'utiliser un match case

          //3.1 entité identifiant (self close):
          if(r("""@.\d+@""".r,entity)){       
              val id = """.\d+""".r.findFirstIn(entity).get
              entity = it.next.toLowerCase
              w_entity=""
              w_entity+= entity+" id=\""+id+"\""
          }else
            
          //3.2 entité FAMC FAMS (self close):
          if(r("""FAM(C|S)""".toLowerCase.r,entity)){
            val id_brut = it.next.toLowerCase
            val id = """.\d+""".r.findFirstIn(id_brut).get 
            w_entity+=" ref=\""+id+"\""
          }else
          
          //3.3 entité SEX (self close)
          if("sex".equals(entity)){
            val sex = it.next.toLowerCase
            w_entity+=" type=\""+sex+"\""
          }else
          
          //3.4 type de famille (self close)
          if(r("""HUSB|WIFE|CHIL""".toLowerCase.r,entity)){
            val id_brut = it.next.toLowerCase
            val id = """.\d+""".r.findFirstIn(id_brut).get
             w_entity+=" ref=\""+id+"\""
          }else
            
          //3.5 fin de document
          if("trlr".equals(entity)){
            num = -1
            w_entity = ""
          }else

          //3.6 entité NAME (self close)
          if("name".equals(entity)){
            var rest = convertSpecial(restOfLine(it," "))
            var array_name = """/""".r split(rest)
            var alias=""//first name
            var sur=""//surname
            if(array_name.length > 0)
              alias+=array_name(0)
            if(array_name.length>1)
              sur+=array_name(1)
            w_entity+=" alias=\""+alias+"\" surname=\""+sur+"\""
          }else
          
          //3.7 entité FILE
          if("file".equals(entity)){
            w_entity+=" ref=\""+restOfLine(it, " ")+"\"" 
          }else
          
          //3.8 entité SOUR
          if("sour".equals(entity)){
            //on cherche si c'est un id:
            var ref = restOfLine(it, " ").split("@")
            if(ref.length==1)
              w_entity+=" ref=\""+ref(0)+"\""
            else
              w_entity+=" ref=\""+ref(1).toLowerCase+"\""
          }
          
          
          //4 - fermer la balise celon le contenu de la pile :
          num match {

            //4.2 égale au num dans la pile
            case n if (n == pile.head._1)  =>
              if(!isClosed(pile.head._2))
                res+="</"+pile.head._2+">"//fermeture balise
              prev_level = pile.head._1
              pile.pop()

            //4.3 inférieur au num dans la pile
            case n if (n < pile.head._1) =>
              while(!(pile.head._1 < num) ){
                if(!isClosed(pile.head._2)){//verifier que nous ne somme pas une balise auto-fermante
                    if(prev_level <= pile.head._1)//debug
                      res+="</"+pile.head._2+">"
                    else
                      res+="\n"+addTab(pile.head._1)+"</"+pile.head._2+">"
                }
                prev_level = pile.head._1
                pile.pop()
              }
              
            case _ =>
          }
          
          //5 ouvrir la balise celon le contenu (sauf quand c'est CONT)
          res+="\n"+addTab(num)
          if( !"cont".equals(entity)){
            pile.push((num,entity))
            if(isClosed(entity))
              res+="<"+w_entity+" />"
            else
              res+="<"+w_entity+">"
          }
          
          //6 on complète avec le reste de ligne
          res+=convertSpecial(restOfLine(it, " "))
          
        }catch {
          case e:Exception => println("problème le format gedcom n'est pas respecté")
        }
      }
    }
    
    //println("le contenu de res =====\n"+res)//TODO: A effacer quand on aura plus besoin de la console
    toFile(replaceExtension(f))
  }

  
  def toFile(filename:String) = {
    val File = new PrintWriter(filename)
    File.write(res)
    File.close()
  }


  /** main*/
  def main(args : Array[String]) {
    
    if(args.length < 1) {
      println("Veuillez fournir un fichier gedcom à traduire");
      System.exit(-1);
    }

    for(arg <- args) {
      if(exists(arg))
	      gedcomToXml(arg);
    }
    
  }
}
