class Note
  DIR_RNS = "#{Dir.home}/.my_rns/"
  def initialize
  end


  """
  Separa la cadena de texto recibida como parametro,
  hasta finalizar la cadena(puede finalizar por el parametro de libro)
  """
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


  """
  Crea una nueva nota en la ruta recibida.
  """
  def create(title,book,route)
      File.write(route,separate())
  end #END CREATE


  """
  Elimina una nota.
  """
  def delete(route)
    File.delete(route)
  end #END DEL DELETE


  """
  Se abre el archivo con tty-editor, el cual ofrece
  al usuario con que editor quiere editar la nota.
  """
  def edit(route)
    TTY::Editor.open(route)
  end
  ###END EDIT


  """
  Asigna el nuevo titulo a una nota
  """
  def retitle(routeOld,routeNew)
    File.rename(routeOld,routeNew)
  end #END RETITLE


  """
  Lista todas las notas de todos los libros,
  incluyendo el libro global.
  """
  def listGlobal(route)
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


  """
  Lista todas las notas de un libro en particular.
  """
  def listRoute(route)
    Dir.foreach(route) do |f|
      next if f == "." or f ==".."
      if File.file?("#{route}#{f}")
        puts "#{f}"
      end
    end
  end #END ROUTE


  """
  Muestra el contenido de una nota.
  """
  def show(route)
    puts File.read(route)
  end #END SHOW


  """
  Obtiene el texto de una nota.
  """
  def obtainText(route)
    File.read(route)
  end #END SHOW


  """
  Exporta una nota de formato de texto plano a html,
  el cual será exportando en la carpeta exports, con el titulo original,
  agregando la hora, minutos y segundos que fue exportado(simplificando asi
  la repitencia de nombres).
  """
  def export(route,title)

    content = File.read(route)
    doc = Markdown.new(content).to_html
    t = Time.now
    routeExport = "#{Dir.home}/exports/#{title}(#{t.strftime("%H,%M,%S")}).html"
    File.write(routeExport,doc)
    puts("el archivo con titulo #{title} fue exportado con exito en #{routeExport}")
  end
  ###END EXPORT


  """
  Exporta todas las notas de formato de texto plano a html,
  los cuales seran exportados en la carpeta exports, cada una con el titulo original,
  agregando la hora, minutos y segundos que fue exportado(simplificando asi
  la repitencia de nombres).

  """
  def exportAll(route)
    Dir.foreach(route) do |f|
      next if f == "." or f ==".."
      routeDir= "#{DIR_RNS}#{f}"
      if File.directory?(routeDir)
        Dir.foreach(routeDir) do |b|
          routeDirBook = "#{routeDir}/#{b}"
          next if b == "." or b ==".."
          content = File.read(routeDirBook)
          doc = Markdown.new(content).to_html
          t = Time.now
          routeExport = "#{Dir.home}/exports/#{b}(from #{f} at #{t.strftime("%H,%M,%S")}).html"
          File.write(routeExport,doc)
        end
      else
        content = File.read(routeDir)
        doc = Markdown.new(content).to_html
        t = Time.now
        routeExport = "#{Dir.home}/exports/#{f}(from global #{t.strftime("%H,%M,%S")}).html"
        File.write(routeExport,doc)
      end
    end
  end


  """
  Exporta todas las notas de formato de texto plano de un libro a html,
  las cuales serán exportadas en la carpeta exports, con el titulo original,
  agregando la hora, minutos y segundos que fue exportado(simplificando asi
  la repitencia de nombres).
  """
  def exportBook(route)
    Dir.foreach(route) do |f|
      next if f == "." or f ==".."
      routeDir = "#{route}#{f}"
      if File.file?(routeDir)
        content = File.read(routeDir)
        doc = Markdown.new(content).to_html
        t = Time.now
        routeExport = "#{Dir.home}/exports/#{f}(#{t.strftime("%H,%M,%S")}).html"
        File.write(routeExport,doc)
      end
    end
  end
end
