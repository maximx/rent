class RentRecordPdf < Prawn::Document
  def initialize(rent_record)
    super()
    @rent_record = rent_record
    hello_text
  end

  #TODO: 補全契約內容
  def hello_text
    text "hihihih"
  end
end
