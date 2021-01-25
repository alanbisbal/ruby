class BooksController < ApplicationController

  def index
    @books = current_user.books
  end

  #display the books of the authenticated user

  def show
    if current_user.books.exists?(params[:id])
      @book = current_user.books.find(params[:id])
      @notes = @book.notes
    else
      render(:file =>File.join(Rails.root,'public/403.html'), :status => 403, :layout => false)
    end
  end

  #create a new book for the authenticated user
  def create
    if !current_user.books.exists?(title: params[:title])
      current_user.books.create(title: params[:title], user_id: current_user.id)
      redirect_to '/books'
    else
      redirect_back(fallback_location: root_path)
    end
  end

  #edit a book for the authenticated user
  def edit
    if current_user.books.exists?(params[:id])
      @book = current_user.books.find(params[:id])
      if @book.title == "Global"
        redirect_to '/'
      end
    else
      redirect_to '/'
    end
  end

  def update
    @books = current_user.books
    if @books.exists?(params[:id]) and !@books.exists?(title: params[:book][:title])
      @book = current_user.books.find(params[:id])
      if @book.title == "Global"
        redirect_to '/'
      end
      @book.update(title: params[:book][:title])
      redirect_to '/books'
    else
      redirect_back(fallback_location: root_path)
    end
  end

  #delete a book and the content for the authenticated user
  def destroy
    if current_user.books.exists?(params[:id])
      @book = current_user.books.find(params[:id])
      if @book.title != "Global"
        @book.destroy
      end
    else
      redirect_to '/'
    end
    redirect_to '/books'
  # AGREGAR ELIMINACION EN CASCADA!
  end


end
