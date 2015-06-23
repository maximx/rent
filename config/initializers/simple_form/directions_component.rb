module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups
    module Directions
      # Name of the component method
      def direction(wrapper_options = nil)
        @direction ||= begin
          options[:direction].to_s.html_safe if options[:direction].present?
        end
      end

      # Used when the number is optional
      def has_direction?
        direction.present?
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Directions)
