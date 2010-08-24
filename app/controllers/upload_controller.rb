class UploadController < ApplicationController
  def index
    render :action => "uploadFile"
  end
  
  def uploadFile
    post = DataFile.save(params[:upload])
    render :text => "File has been uploaded successfully"
  end

end
