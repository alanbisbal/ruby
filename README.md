
## Documentacion para usuario final.


### Instalación de dependencias.

Este proyecto utiliza Bundler para manejar sus dependencias.

```bash
$ bundle install
```
### Objetivo.
  Ruby notes, o simplemente rn, es un gestor de notas simple, el cual
  permite almacenar la informacion de tus notas en texto plano mediante CLI.
  Tambien permite la creacion de libros, donde podes guardar tus diferentes notas.

### Manejo del proyecto.

Para ejecutar el comando principal de la herramienta se utiliza el script `bin/rn`, el cual puede correrse de las siguientes manera:

```bash
$ ruby bin/rn [args]
```

O bien:

```bash
$ bundle exec bin/rn [args]
```

O simplemente:

```bash
$ bin/rn [args]
```

  El proyecto rn cuanta con el siguiente conjunto de funciones:

  * note create: permite crear una nota.
  * note delete: permite eliminar una nota.
  * note edit: permite editar una nota.
  * note retitle: permite retitular una nota.
  * note list: permite listar todas las notas de un libro en particular o de todos.
  * note show: permite ver el contenido de una nota.
  * note export: permite exportar una nota, todas de un libro en particular, o todas las notas.


  * book create: permite crear un libro.
  * book delete: permite eliminar un libro.
  * book list: permite listar en contenido de un libro.
  * book rename: permite renombrar un libro.

  Para obtener información sobre el uso de estos comandos, puede utilizar, por ejemplo:
  ```
  bin/rn note create
  Y obtendrá como resultado:

  'todo                        # Creates a note titled "todo" in the global book',
  '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
  'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'

  De esta manera puede obtener que parametros permite cada funcion y cual es su objetivo.
  ```

### Textos ricos:

  Una de las funcionalidades principales del rn es poder crear textos ricos,
  mediante el uso de la gema Markdown, la cual nos permite generar una conversión
  de texto plano a html.

  Para utilizar la herramienta podés utilizar cualquiera de los siguientes comandos
  sobre el texto, para que sean implementados a la hora de exportar.

  [Markdown](https://markdown-it.github.io).


Alan Bisbal.
