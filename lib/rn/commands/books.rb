module RN
  module Commands
    module Books
      DIR_RNS = "#{Dir.home}/.my_rns/"
      class Create < Dry::CLI::Command
        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **)
          route = "#{DIR_RNS}#{"#{name}" if name}"
          if Dir.exist?(route)
            print "ya existe una libro con ese nombre\n"
          else
            Dir.mkdir(route)
            print "el libro con nombre '#{name}' fue creada con exito\n"
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          route = "#{DIR_RNS}#{"#{name}" if name}"
          if Dir.exist?(route)
            Dir.rmdir(route)
            print "el libro con nombre '#{name}' fue borrado con exito\n"
          else
            print "no existe una libro con ese nombre\n"
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          route = "#{DIR_RNS}"
          Dir.foreach(route) do |f|
            next if f == "." or f ==".."
            routedir= "#{DIR_RNS}#{f}"
            if File.directory?(routedir)
              Dir.foreach(routedir) do |b|
                next if b == "." or b ==".."
                puts "#{b} in #{routedir}"
              end
            else
            puts "#{f}<-- in global"
            end
          end
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
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
    end
  end
end
