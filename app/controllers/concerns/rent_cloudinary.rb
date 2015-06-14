module RentCloudinary

  private

    def set_picture_public_id
      if params[model_name].has_key?(:pictures_attributes)
        pictures_attributes["0"][:public_id].each_with_index do |picture, index|
          pictures_attributes["#{index}"] = { public_id: upload_to_cloudinary(picture, index) }
        end
      elsif params[model_name].has_key?(:picture_attributes)
        picture_attributes[:public_id] = upload_to_cloudinary picture_attributes[:public_id]
      end
    end

    def upload_to_cloudinary(pic)
      logger.info pic
      Cloudinary::Uploader.upload(pic, use_filename: true)["public_id"]
    end

    def pictures_attributes
    # item, requirement
      params[model_name][:pictures_attributes]
    end

    # user profile
    def picture_attributes
      params[model_name][:picture_attributes]
    end

    def model_name
      params[:controller].singularize
    end

end
