class AttachmentsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource

  def destroy
    if @attachment.destroy
      result = { result: 'ok' }

      flash[:notice] =  t('controller.attachments.destroy.success',
                          name: @attachment.original_filename)
    else
      result = { result: 'false' }

      flash[:alert] =  t('controller.attachments.destroy.fail',
                          name: @attachment.original_filename)
    end

    respond_to do |format|
      format.json { render json: result if request.xhr? }
      format.html { redirect_to :back }
    end
  end

  def download
    data = open @attachment.file_url
    send_data data.read,
              type: @attachment.content_type,
              x_sendfile: true,
              filename: @attachment.original_filename
  end
end
