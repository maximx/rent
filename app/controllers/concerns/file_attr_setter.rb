module FileAttrSetter
  private

    def set_avatar_attr
      set_file_attr model_name: 'profile', attributes_name: 'avatar'
    end

    def set_attachments_attr
      set_file_attr controller: 'rent_records', model_name: 'rent_record_state_log', attributes_name: 'attachments'
    end

    def set_pictures_attr
      set_file_attr model_name: 'item', attributes_name: 'pictures'
    end

    def set_file_attr(options)
      model_name = options[:model_name]
      attributes_name = options[:attributes_name]
      attributes = "#{attributes_name}_attributes"
      controller_name = options[:controller] || options[:model_name].pluralize

      if view_context.send "#{controller_name}_controller?"
        if file_selected? model_name, attributes
          if file_multiple? attributes_name
            params[model_name][attributes]["0"][:public_id].each_with_index do |p, index|
              params[model_name][attributes]["#{index}"] = { public_id: p.original_filename, file_cached: p }
            end
          else
            params[model_name][attributes][:file_cached] =  params[model_name][attributes][:public_id]
            params[model_name][attributes][:public_id] = params[model_name][attributes][:file_cached].original_filename
          end
        else
          # avoid file delete
          if model_name == 'rent_record_state_log'
            params[model_name] = { info: nil }
          else
            params[model_name].delete(attributes)
          end
        end
      end
    end

    def set_pictures_attrs_backup
      if view_context.items_controller? and pictures_selected?
        pictures_attributes["0"][:public_id].each_with_index do |picture, index|
          pictures_attributes["#{index}"] = { public_id: picture.original_filename, file_cached: picture }
        end
      end
    end

    # item
    def pictures_attributes
      params[model_name][:pictures_attributes]
    end

    def model_name
      params[:controller].singularize
    end

    def pictures_selected?
      params[model_name].has_key?(:pictures_attributes)
    end

    def file_multiple?(attributes_name)
      attributes_name.pluralize == attributes_name
    end

    def file_selected?(model_name, attributes)
      params.has_key?(model_name) and
        params[model_name].has_key?(attributes) and (
          params[model_name][attributes].has_key?(:public_id) or
          params[model_name][attributes].has_key?("0")
        )
    end
end
