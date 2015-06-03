class RentRecordPdf < Prawn::Document

  def self.pdf_config(item_id, rent_record_id)
    {
      filename: "item#{item_id}_record#{rent_record_id}.pdf",
      type: "application/pdf",
      disposition: :inline
    }
  end

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
