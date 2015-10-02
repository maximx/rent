class PicturesController < ApplicationController
  before_action :login_required
  before_action :find_item, :find_item_picture, only: [ :destroy ]
  before_action :find_rent_record_state_log_attachment, :validate_permission, only: [ :download ]

  def destroy
    unless @picture.only_one?
      @picture.destroy
      result = { result: "ok" }
    else
      result = { result: "false" }
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  def download
    send_data Cloudinary::Downloader.download(@attachment.public_id), filename: @attachment.public_id
  end

  private
    def find_item
      @item = current_user.items.find(params[:item_id])
    end

    def find_item_picture
      @picture = @item.pictures.find(params[:id])
    end

    def find_rent_record_state_log_attachment
      @attachment = Picture.find params[:id]
    end

    def validate_permission
      obj = @attachment.imageable
      unless obj.is_a? RentRecordStateLog and obj.rent_record.viewable_by?(current_user)
        flash[:alert] = '您沒有權限'
        redirect_to items_path
      end
    end
end
