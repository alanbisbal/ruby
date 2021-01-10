class BooksController < ApplicationController

  def index
    @books = Book.all
  end

  def show
  end

  def create
  end

  def update
  end
end
