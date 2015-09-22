module PicturesAttrsSetter
  private

    def set_picture_attrs
      if view_context.items_controller? and picture_selected?
        pictures_attributes["0"][:public_id].each_with_index do |picture, index|
          pictures_attributes["#{index}"] = { public_id: picture.original_filename, file_cached: picture }
        end
      elsif view_context.profiles_controller?
        if picture_attributes.has_key?(:public_id)
          picture_attributes[:file_cached] =  picture_attributes[:public_id]
          picture_attributes[:public_id] = picture_attributes[:file_cached].original_filename
        else
          # avoid picture delete
          params[model_name].delete(:picture_attributes)
        end
      end
    end

    # item
    def pictures_attributes
      params[model_name][:pictures_attributes]
    end

    # user profile
    def picture_attributes
      params[model_name][:picture_attributes]
    end

    def model_name
      params[:controller].singularize
    end

    def picture_selected?
      params[model_name].has_key?(:pictures_attributes)
    end
end
