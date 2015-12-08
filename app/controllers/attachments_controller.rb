class AttachmentsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource

  def destroy
    if request.xhr? and @attachment.destroy
      result = { result: 'ok' }
    else
      result = { result: 'false' }
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  def download
    data = open @attachment.file_url
    send_data data.read, type: data.content_type, x_sendfile: true, filename: @attachment.original_filename
  end
end
