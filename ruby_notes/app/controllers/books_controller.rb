class BooksController < ApplicationController

  def index
    @books = Book.where(user_id: current_user.id)
  end

  def show
    @book = Book.find(params[:id])
    @notes = @book.notes
  end

  def create
  end

  def edit
  end

  def destroy

  end

end
