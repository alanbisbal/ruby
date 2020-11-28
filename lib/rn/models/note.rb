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


  def create(title,book,route)
      File.write(route,separate())
  end #END CREATE


  def delete(route)
    File.delete(route)
  end #END DEL DELETE

  def edit(route)
    TTY::Editor.open(route)
  end
  ###END EDIT

  def retitle(routeOld,routeNew)
    File.rename(routeOld,routeNew)
  end #END RETITLE

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


  def listRoute(route)
    Dir.foreach(route) do |f|
      next if f == "." or f ==".."
      if File.file?("#{route}#{f}")
        puts "#{f}"
      end
    end
  end #END ROUTE


  def show(route)
    puts File.read(route)
  end #END SHOW


  def obtainText(route)
    File.read(route)
  end #END SHOW


  def export(route,title)

    content = File.read(route)
    doc = Markdown.new(content).to_html
    t = Time.now
    routeExport = "#{Dir.home}/exports/#{title}(#{t.strftime("%H,%M,%S")}).html"
    File.write(routeExport,doc)
    puts("el archivo con titulo #{title} fue exportado con exito en #{routeExport}")
  end
  ###END EXPORT

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
