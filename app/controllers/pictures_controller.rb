class PicturesController < ApplicationController
  before_action :login_required
  before_action :find_item, only: [ :destroy ]
  before_action :find_picture, only: [ :destroy ]

  def destroy
    unless @picture.only_one?
      result = Cloudinary::Uploader.destroy(@picture.public_id)
      @picture.destroy
    else
      result = { result: "false" }
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  private

    def find_item
      @item = current_user.items.find(params[:item_id])
    end

    def find_picture
      @picture = @item.pictures.find(params[:id])
    end

end
