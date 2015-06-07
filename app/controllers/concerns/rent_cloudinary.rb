module RentCloudinary

  def set_public_id
    if params[model_name].has_key?(:pictures_attributes)
      pictures_attributes["0"][:public_id].each_with_index do |picture, index|
        pictures_attributes["#{index}"] = { public_id: upload_to_cloudinary(picture) }
      end
    end
  end

  def upload_to_cloudinary(pic)
    Cloudinary::Uploader.upload(pic)["public_id"]
  end

  def pictures_attributes
    params[model_name][:pictures_attributes]
  end

  def model_name
    params[:controller].singularize
  end

end
