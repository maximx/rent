class PicturesController < ApplicationController
  before_action :login_required
  before_action :find_item, only: [ :destroy ]
  before_action :find_picture, only: [ :destroy ]

  def destroy
    @cloudinary_info = Cloudinary::Uploader.destroy(@picture.public_id)
    @picture.destroy

    respond_to do |format|
      format.json { render json: @cloudinary_info }
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
