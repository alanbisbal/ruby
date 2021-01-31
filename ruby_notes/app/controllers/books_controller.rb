class BooksController < ApplicationController
  require 'zip'
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
    if params[:title].blank?
      flash.alert = "The title can't be blank"
      redirect_back(fallback_location: root_path)
    elsif current_user.books.exists?(title: params[:title])
      flash.alert = "The name is alredy in use"
      redirect_back(fallback_location: root_path)
    else
      current_user.books.create(title: params[:title], user_id: current_user.id)
      redirect_to '/books'
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
      render(:file =>File.join(Rails.root,'public/403.html'), :status => 403, :layout => false)
    end
  end

  def update
    if params[:book][:title].blank?
      flash.alert = "The title can't be blank"
      redirect_back(fallback_location: root_path)
    elsif current_user.books.exists?(title: params[:book][:title])
      flash.alert = "The name is alredy in use"
      redirect_back(fallback_location: root_path)
    else

    @books = current_user.books
    if @books.exists?(params[:id])
      @book = current_user.books.find(params[:id])
      if @book.title == "Global"
        flash.alert = "Cant update Global book"
        redirect_to '/'
      end
      @book.update(title: params[:book][:title])
      redirect_to '/books/'
    else
      render(:file =>File.join(Rails.root,'public/403.html'), :status => 403, :layout => false)

    end
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
      render(:file =>File.join(Rails.root,'public/403.html'), :status => 403, :layout => false)
    end
    redirect_to '/books'

  end

  def download_notes
    @notes = current_user.books.find(params[:book_id]).notes
    stringio = Zip::OutputStream.write_buffer do |zio|
      @notes.each do |coverage|
        #create and add a text file for this record
        zio.put_next_entry("#{coverage.id}_test.txt")
        zio.write "#{coverage.title}!"
        #create and add a pdf file for this record
        dec_pdf = render_to_string :pdf => "#{coverage.id}_dec.pdf", :template => 'books/download', :locals => {coverage: coverage}
        zio.put_next_entry("#{coverage.id}_dec.pdf")
        zio << dec_pdf
      end
    end
    # This is needed because we are at the end of the stream and
    # will send zero bytes otherwise
    stringio.rewind
    #just using variable assignment for clarity here
    binary_data = stringio.sysread
    send_data(binary_data, :type => 'application/zip', :filename => "test_dec_page.zip")
  end

end
