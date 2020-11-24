class Note
  DIR_RNS = "#{Dir.home}/.my_rns/"
  def initialize
  end

  def separate()
    text = ""
    3.times {ARGV.delete_at(0)}
    ARGV.each do |element|
       if element != "--book" and element !="-b" #MEJORAR IMPLEMENTACION, Y AGREGAR --BOOK. regexp?
         text << element + " "
       else
         return text
       end
    end
    text
  end


  def create(title,book)
      route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
      if File.exist?(route)
        print "ya existe una nota con ese titulo\n"
      else
      File.write(route,separate())
      print "la nota con titulo '#{title}' fue creada con exito (en el libro '#{book}')\n"
      end
  end #END CREATE


  def delete(title,book)
    route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
    if File.exist?(route)
      File.delete(route)
      print "la nota con titulo '#{title}' fue eliminada con exito (en el libro '#{book}') \n"
    else
      print "la nota con titulo '#{title}' no existe (en el libro '#{book}')\n"
    end
  end #END DEL DELETE

  def edit(title,book)
    route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
    if File.exist?(route)
      TTY::Editor.open(route)
    else
      print "la nota con titulo '#{title}' no existe (en el libro '#{book}')\n"
    end
  end
  ###END EDIT

  def retitle(new_title,old_title,book)
    routeOld = "#{DIR_RNS}#{"#{book}/" if book}#{old_title}.rn"
    routeNew = "#{DIR_RNS}#{"#{book}/" if book}#{new_title}.rn"
    if !File.exist?(routeOld)
       print "la nota con titulo '#{old_title}' no existe (en el libro '#{book}')\n"
       return
    end
    if File.exist?(routeNew)
       print "ya existe otra nota con el nuevo titulo '#{new_title}'(en el libro '#{book}'), eliga otro nombre.\n"
       return
    end
    File.rename(routeOld,routeNew)
    print "El nombre de la nota '#{old_title}' fue modificado a '#{new_title}' con exito.\n"
  end #END RETITLE

  def printGlobal(route)
    Dir.foreach(route) do |f|
      next if f == "." or f ==".."
      routedir= "#{DIR_RNS}#{f}"
      if File.directory?(routedir)
        Dir.foreach(routedir) do |b|
          next if b == "." or b ==".."
          puts "#{b} ---- #{routedir}"
        end
      else
        puts "#{f} ---- global"
      end
    end
  end #END PRINTGLOBAL


  def printRoute(route)
    Dir.foreach(route) do |f|
      next if f == "." or f ==".."
      if File.file?("#{route}#{f}")
        puts "#{f}"
      end
    end
  end #END ROUTE

  def list(book,global)
    route = "#{DIR_RNS}"
    if book
      route = "#{DIR_RNS}#{book}/"
      printRoute (route)
    elsif global
      route = "#{DIR_RNS}"
      printRoute (route)
    else
      route = "#{DIR_RNS}"
      printGlobal(route)
    end
  end #END LIST


  def show(title,book)
    route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
    puts File.read(route)
  end #END SHOW



  def export()

  end
  ###END EXPORT

end
