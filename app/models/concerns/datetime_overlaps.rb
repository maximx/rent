module DatetimeOverlaps
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

    before_validation :set_ended_at
  end

  def ended_date
    ended_at.present? ? ended_at.to_date : ended_at
  end

  private
    #只有日期 ended_at + 1.day，為整點減去一秒避免 overlap
    def set_ended_at
      if self.new_record? and ended_at.present?
        self.ended_at = ended_date + (1.day - 1.second)
      end
    end
end
