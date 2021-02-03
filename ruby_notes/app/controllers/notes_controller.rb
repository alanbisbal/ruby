class NotesController < ApplicationController
  def index
    redirect_to '/'
  end

  def show
    @books = current_user.books
    ok = false
    for book in @books
      if book.containNote(params[:id])
        @note = Note.where(id: params[:id]).first()
        ok = true
        break
      end
    end
    if !ok
      flash.alert = "The note does not exist"
      redirect_to '/'
    end
  end

  def create
    if params[:title].blank?
      flash.alert = "The title can't be blank"
      redirect_back(fallback_location: root_path)
    elsif params[:content].blank?
      flash.alert = "The content can't be empty"
      redirect_back(fallback_location: root_path)
    else
    current_user.books.find(params[:book_id]).notes.create(title: params[:title],content:params[:content], book_id: params[:book_id])
    redirect_to ( '/books/'+params[:book_id])
  end
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
    if params[:note][:title].blank?
      flash.alert = "The title can't be blank"
      redirect_back(fallback_location: root_path)
    elsif params[:note][:content].blank?
      flash.alert = "The content can't be empty"
      redirect_back(fallback_location: root_path)
    else
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
      @note.update(title: params[:note][:title],content:params[:note][:content], book_id: params[:note][:book_id])
    end
    redirect_to ( '/books/'+params[:note][:book_id])
  end
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

  def download
       @note = Note.find(params[:note_id])
       html = render_to_string(:action => :download, :layout => false)
       pdf = WickedPdf.new.pdf_from_string(html)
       send_data(pdf,
           :filename    => "temp.pdf",
           :disposition => 'attachment')
    end
end
