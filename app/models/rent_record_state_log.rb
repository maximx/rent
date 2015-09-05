class RentRecordStateLog < ActiveRecord::Base
  belongs_to :rent_record
  belongs_to :user
end
