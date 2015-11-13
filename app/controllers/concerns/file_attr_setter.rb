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
          attr_params = params[model_name][attributes]

          if file_multiple? attributes_name
            attr_params["0"][:public_id].each_with_index do |p, index|
              attr_params["#{index}"] = { public_id: p.original_filename, file_cached: p }
            end
          else
            attr_params[:file_cached] =  attr_params[:public_id]
            attr_params[:public_id] = attr_params[:file_cached].original_filename
          end
        else
          # avoid file delete
          if model_name == 'rent_record_state_log'
            params[model_name] = { info: nil }
          else
            params[model_name].delete attributes
          end
        end
      end
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
