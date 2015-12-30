module ScopeOverlaps
  extend ActiveSupport::Concern

  included do
    scope :overlaps, ->(started_at, ended_at) do
      model_name = name.underscore.pluralize
      where_condition = "(TIMESTAMPDIFF(SECOND, #{model_name}.started_at, ?) *"\
                        " TIMESTAMPDIFF(SECOND, ?, #{model_name}.ended_at)) >= 0"

      objects = where(where_condition, ended_at, started_at)
      objects = objects.actived if respond_to?('actived')
      objects
    end
  end
end
