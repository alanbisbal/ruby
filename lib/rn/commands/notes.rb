module RN
  module Commands
    module Notes
      DIR_RNS = "#{Dir.home}/.my_rns/"
      class Create < Dry::CLI::Command
        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]
        #PARSEA EL TEXTO ELIMINANDO LOS 3 PRIMEROS PARAMETROS N CREATE Y EL TITULO DE LA NOTA
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

        #crea la nota con un titulo, un contenido si se lo envia, hasta que se presione enter
        #o reciba un libro como parametro
        def call(title:, **options)
          book = options[:book]
          route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
          if File.exist?(route)
            print "ya existe una nota con ese titulo\n"
          else
            File.write(route,separate())
            print "la nota con titulo '#{title}' fue creada con exito (en el libro '#{book}')\n"
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]
        def call(title:, **options)
          book = options[:book]
          route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
          if File.exist?(route)
            File.delete(route)
            print "la nota con titulo '#{title}' fue eliminada con exito (en el libro '#{book}') \n"
          else
            print "la nota con titulo '#{title}' no existe (en el libro '#{book}')\n"
          end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)

          book = options[:book]
          route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
          if File.exist?(route)
            TTY::Editor.open(route)
          else
            print "la nota con titulo '#{title}' no existe (en el libro '#{book}')\n"
          end
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          book = options[:book]
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
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]


        def printGlobal(route)
          Dir.foreach(route) do |f|
            next if f == "." or f ==".."
            routedir= "#{DIR_RNS}#{f}"
            if File.directory?(routedir)
              Dir.foreach(routedir) do |b|
                next if b == "." or b ==".."
                puts "#{b} in #{routedir}"
              end
            else
              puts "#{f} <-- in global"
            end
          end
        end


        def printRoute(route)
          Dir.foreach(route) do |f|
            next if f == "." or f ==".."
            if File.file?("#{route}#{f}")
              puts "#{f}"
            end
          end
        end


        def call(**options)
          book = options[:book]
          global = options[:global]
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
        end

      end

      class Show < Dry::CLI::Command
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
          puts File.read(route)

        end
      end
    end
  end
end
