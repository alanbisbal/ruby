class NotesController < ApplicationController

  def show
    ##MODULARIZAR EN UN HELPER O CALL A METODO DE MODELO
    @books = current_user.books
    ok = false
    for book in @books
      if book.containNote(params[:id])
        @note = Note.where(id: params[:id]).first()
        ok = true
        break
      end
    end
    ##MODULARIZAR
    if @note
       @note
    else
      redirect_to '/'
    end
  end

  def create
    current_user.books.find(params[:book_id]).notes.create(title: params[:title],content:params[:content], book_id: params[:book_id])
    redirect_to ( '/books/'+params[:book_id])
  end

  def edit
    @books = current_user.books
    ok = false
    for book in @books
      if book.containNote(params[:id])
        @note = Note.where(id: params[:id]).first()
        ok = true
        break
      end
    end
    ##MODULARIZAR
    if @note
       @note
    else
      redirect_to '/'
    end
  end

  def update
    @books = current_user.books
    ok = false
    for book in @books
      if book.containNote(params[:id])
        @note = Note.where(id: params[:id]).first()
        ok = true
        break
      end
    end
    ##MODULARIZAR
    if @note
      @note.update(title: params[:note][:title],content:params[:note][:content], book_id: params[:note][:book_id])
    end
    redirect_to ( '/books/'+params[:note][:book_id])
  end

  def destroy
    @books = current_user.books
    ok = false
    for book in @books
      if book.containNote(params[:id])
        @note = Note.where(id: params[:id]).first()
        ok = true
        break
      end
    end
    if @note
      @note.destroy
    else
      redirect_to '/'
    end
    redirect_to '/books'
  end

end
