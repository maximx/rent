class PicturesController < ApplicationController
  before_action :login_required, :find_picture
  before_action :viewable?, only: [ :download ]

  def destroy
    if @picture.editable_by?(current_user) and @picture.destroy
      result = { result: "ok" }
    else
      result = { result: "false" }
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  def download
    send_data Cloudinary::Downloader.download(@picture.public_id), filename: @picture.filename
  end

  private
    def find_picture
      @picture = Picture.find params[:id]
    end

    def viewable?
      redirect_with_message(item_rent_records_path) unless @picture.viewable_by?
    end
end
