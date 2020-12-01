module RN
  module Commands
    module Books
      DIR_RNS = "#{Dir.home}/.my_rns/"


      class Create < Dry::CLI::Command
        """
        Se recibe un nombre como argumento, se crea una instancia de book
        y le envia el mensaje create con el parametro para su creación

        """
        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **)
          b = Book.new
          b.create(name)
        end
      end

      class Delete < Dry::CLI::Command
        """
        se recibe un nombre como argumento opcional, para eliminar todas las notas
        del mismo, ubicado dentro de la carpeta .my_rns.
        O puede recibir el argumento --global para eliminar todas las notas del
        directorio global
        """
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          b = Book.new
          b.delete(name)
        end
      end

      class List < Dry::CLI::Command
        """
        Lista todos los libros dentro del directorio .my_rns
        """
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          b = Book.new
          b.list()
        end

      end
      class Rename < Dry::CLI::Command
        """
        recibe un argumento con el nombre del libro a modificar, y el nuevo nombre del libro.

        """
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          b = Book.new
          b.rename(old_name,new_name)
        end
      end
    end
  end
end
