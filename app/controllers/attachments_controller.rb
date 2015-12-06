class AttachmentsController < ApplicationController
  before_action :login_required, :find_attachment
  before_action :viewable?, only: [ :download ]

  def destroy
    if @attachment.editable_by?(current_user) and @attachment.destroy
      result = { result: 'ok' }
    else
      result = { result: 'false' }
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  def download
    #send_data Cloudinary::Downloader.download(@attachment.public_id), filename: @attachment.filename
  end

  private
    def find_attachment
      @attachment = Attachment.find params[:id]
    end

    def viewable?
      redirect_with_message(item_records_path) unless @attachment.viewable_by? current_user
    end
end
