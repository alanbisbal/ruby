module RN
  module Commands
    module Notes

    DIR_RNS = "#{Dir.home}/.my_rns/"
    class Create < Dry::CLI::Command
        """
        Se recibe el nombre de la nota(obligatorio), un contenido(opcional)
        el cual puede ser recibido en una sola linea o en varias lineas utilizando " ".
        Tambien puede recibir con la opcion --book o -b en que libro desea guardarla,
        en caso de que el libro exista. Sino será almacenada en el directorio global

        """

        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          n=Note.new()
          route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
          if File.exist?(route)
            print "ya existe una nota con ese titulo\n"
          else
            n.create(title,book,route)
          print "la nota con titulo '#{title}' fue creada con exito (en el libro '#{book}')\n"
          end
        end

      end

      class Delete < Dry::CLI::Command
        """
        Se recibe un nombre(obligatorio), con el cual busca y elimina
        una nota del directorio global.
        Tambien se puede usar la opcion --book o -b para eliminar la nota de
        un libro en particular
        """
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
          n = Note.new
          route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
          if File.exist?(route)
            n.delete(route)
            print "la nota con titulo '#{title}' fue eliminada con exito (en el libro '#{book}') \n"
          else
            print "la nota con titulo '#{title}' no existe (en el libro '#{book}')\n"
          end
        end

      end

      class Edit < Dry::CLI::Command
        """
        Se recibe el nombre de una nota, y en caso de existir
        se ofrecerá mediante una gema (tty-editor) con que editor se quiere
        abrir el archivo.
        Tambien se puede enviar como opcional en que libro se encuentra la nota .
        """
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
          n = Note.new
          route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
          if File.exist?(route)
            n.edit(route)
          else
            print "la nota con titulo '#{title}' no existe (en el libro '#{book}')\n"
          end
        end
      end

      class Retitle < Dry::CLI::Command
        """
        Permite renombrar una nota recibiendo como primer argumento
        el titulo de la nota a buscar, y como segundo argumento el nuevo
        nombre de la nota. En caso de que el nuevo titulo ya este en uso
        por otra nota, entonces se informará que ya existe una nota con ese nombre
        no se hace nada.
        Tambien se puede enviar como parametro opcional en que libro se encuentra
        la nota a renombrar.
        """
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
          n = Note.new
          n.retitle(routeOld,routeNew)
          print "El nombre de la nota '#{old_title}' fue modificado a '#{new_title}' con exito.\n"
          end
      end

      class List < Dry::CLI::Command
        """
        Permite listar todas las notas si no se envian parametros(de los libros y globales)
        o bien, listar solo las notas del directorio global, o listar las notas
        de un libro en particular.
        """
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def call(**options)
          book = options[:book]
          global = options[:global]
          n = Note.new
          route = "#{DIR_RNS}"
          if book
            route = "#{DIR_RNS}#{book}/"
            if File.exist?(route)
              n.listRoute (route)
            else
              puts "El libro con nombre #{book} no existe"
            end
          elsif global
            route = "#{DIR_RNS}"
            n.listRoute (route)
          else
            route = "#{DIR_RNS}"
            n.listGlobal(route)
          end
        end
      end

      class Show < Dry::CLI::Command
        """
        Permite mostrar el contenido de una nota en particular
        recibiendo el titulo de dicha nota como argumento(obligatorio).
        Tambien se puede enviar en que libro se encuentra esa nota de forma
        opcional.
        """
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
          n = Note.new
          route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
          if File.exist?(route)
            n.show(route)
          else
            puts "No existe el titulo '#{title}' (en el libro '#{book}')"
          end
        end
      end


      class Export < Dry::CLI::Command
        """
        Permite exportar una nota en particular del libro global,
        recibiendo por parametro el nombre de la nota.
        Tambien puede enviarse como opcional en que libro se encuentra la nota.
        O bien enviando el comando --all exporta todas las notas de todos los libros
        incluyendo el global.
        Las notas en formato de texto plano, son convertidas a formatos
        HTML, haciendo uso de textos ricos implementado con la gema Markdown.
        """
        desc 'Export notes'

        argument :title,type: :string,desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'
        option :all, type: :boolean, default: false, desc: 'Export all notes from the all books'

        example [
          'todo                    # Export one note(including in the global book)',
          'todo --book Memoires    # Export one note from the book named "Memoires"',
          '--all                   # Export all notes from all books(including the global book)'
        ]


        def call(title:nil,**options)
          book = options[:book]
          all = options[:all]
          n = Note.new
          if all
            route = "#{DIR_RNS}"
            n.exportAll(route)
            return
          end
          if title
            route = "#{DIR_RNS}#{"#{book}/" if book}#{title}.rn"
          if File.exist?(route)
            n.export(route,title)
          else
            puts "no existe una nota con el titulo '#{title}'(en el libro'#{book}')"
          return
            end
          end
          if book
            route = "#{DIR_RNS}#{"#{book}/" if book}"
            n.exportBook(route)
          end
        end
      end
    end
  end
end
