class Book
  DIR_RNS = "#{Dir.home}/.my_rns/"
  def initialize
    
  end


  def create(name)
    route = "#{DIR_RNS}#{"#{name}" if name}"
    if Dir.exist?(route)
      print "ya existe una libro con ese nombre\n"
    else
      Dir.mkdir(route)
      print "el libro con nombre '#{name}' fue creada con exito\n"
    end
  end

  def delete(name)
    route = "#{DIR_RNS}#{"#{name}" if name}"
    if Dir.exist?(route)
       Dir.foreach(route) do |f|
          next if f == "." or f ==".."
          File.delete("#{route}/#{f}")
        end
      Dir.rmdir(route)
      print "el libro con nombre '#{name}' fue borrado con exito\n"
    else
      print "no existe una libro con ese nombre\n"
    end

  end


  def list()
    route = "#{DIR_RNS}"
    Dir.foreach(route) do |f|
      routedir= "#{DIR_RNS}#{f}"
      if File.directory?(routedir)
        next if f == "." or f ==".."
        puts "#{f}"
      end
    end
  end


  def rename(old_name,new_name)
    routeOld = "#{DIR_RNS}#{"#{old_name}" if old_name}"
    routeNew = "#{DIR_RNS}#{"#{new_name}" if new_name}"
    if !Dir.exist?(routeOld)
       print "el libro '#{old_name}' no existe \n"
       return
    end
    if Dir.exist?(routeNew)
       print "ya existe otro libro con nombre '#{new_name}', eliga otro nombre.\n"
       return
    end
    File.rename(routeOld,routeNew)
    print "El nombre de la nota '#{old_name}' fue modificado a '#{new_name}' con exito.\n"
  end





end
