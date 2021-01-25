class DownloaderController < ApplicationController

  def download
  @note = Note.find(params[:format])
  if @note.book.user.id == current_user.id
    pdf = WickedPdf.new.pdf_from_string(            #1
      render_to_string('download', layout: false))  #2
      send_data(pdf,                                  #3
        filename: 'download.pdf',                     #4
        type: 'application/pdf',                      #5
        disposition: 'attachment')                    #6
  else
    render(:file =>File.join(Rails.root,'public/403.html'), :status => 403, :layout => false)
    end
  end

end
