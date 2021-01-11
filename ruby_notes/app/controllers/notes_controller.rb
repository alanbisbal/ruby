class NotesController < ApplicationController
  def index
  end

  def show
    @note = Note.find(params[:id])
  end

  def create
  end

  def edit
    
  end

  def destroy

  end
end
