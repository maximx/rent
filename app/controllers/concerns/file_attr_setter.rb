module FileAttrSetter
  private

    def set_picture_attrs
      if view_context.profiles_controller?
        if params[model_name][:picture_attributes].has_key?(:public_id)
          set_attrs( params[model_name][:picture_attributes] )
        else
          # avoid picture delete
          params[model_name].delete(:picture_attributes)
        end
      end
    end

    def set_pictures_attrs
      if view_context.items_controller? and picture_selected?
        pictures_attributes["0"][:public_id].each_with_index do |picture, index|
          pictures_attributes["#{index}"] = { public_id: picture.original_filename, file_cached: picture }
        end
      end
    end

    def set_attachment_attrs
      if view_context.rent_records_controller?
        if attchment_selected?
          set_attrs( params['rent_record_state_log'][:attachments_attributes]["0"] )
        else
          params['rent_record_state_log'] = { info: nil }
        end
      end
    end

    def set_attrs(file_attributes)
      file_attributes[:file_cached] =  file_attributes[:public_id]
      file_attributes[:public_id] = file_attributes[:file_cached].original_filename
    end

    # item
    def pictures_attributes
      params[model_name][:pictures_attributes]
    end

    def model_name
      params[:controller].singularize
    end

    def picture_selected?
      params[model_name].has_key?(:pictures_attributes)
    end

    def attchment_selected?
      params.has_key?(:rent_record_state_log)
    end
end
