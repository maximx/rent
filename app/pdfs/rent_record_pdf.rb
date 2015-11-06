class RentRecordPdf < Prawn::Document
  def self.pdf_config(item_id, rent_record_id)
    {
      filename: "item#{item_id}_record#{rent_record_id}.pdf",
      type: 'application/pdf',
      disposition: :inline
    }
  end

  def initialize(item, rent_record)
    super()
    @item = item
    @rent_record = rent_record

    font "#{Rails.root.join("app", "assets", "fonts", "华文仿宋.ttf")}"

    declare_code
    first_code
    second_code
    third_code
    fourth_code
    fifth_code
    sixth_code
    seventh_code
    eighth_code
    ninth_code
    tenth_code
    eleventh_code
    twelfth_code
    sign_table
  end

  def declare_code
    text '出租合約書', size: 20, align: :center
    move_down 15

    text "#{@rent_record.borrower.account}（以下簡稱甲方）向#{@item.lender.account}（以下簡稱乙方）承租 #{@item.name} 特訂立本契約並經雙方同意，條件如下∶"
    next_line
  end

  def first_code
    text <<-CODE
      第一條∶租期
      本合約以標的物驗收手續完成後隔日起租，標的物返還時間以本合約規定為準。
    CODE

    text "自 #{date_format(@rent_record.started_at)} 起，"\
         "至 #{date_format(@rent_record.ended_at)} 止，共計 #{@rent_record.rent_days} 天。"
    next_line
  end

  def second_code
    text <<-CODE
      第二條∶押金、押證件
      一、甲方承租標的物時，可質押相關證件予乙方或供乙方拍照，亦可按合約規定之金額支付押金。
      二、甲方質押之證件、押金，於合約終止時若無維修等相關問題時，由乙方歸還甲方。否則待維修完成後，再予以歸還。
      三、乙方有義務於租約期間保管甲方質押之證件，且不得擅自使用甲方之證件，亦不得直接或間接提供予第三人使用。
    CODE
    next_line
  end

  def third_code
    text <<-CODE
      第三條∶租賃物返還與違約罰款
      一、甲方應於本合約屆滿或終止時將標的物返還乙方。
      二、甲方歸還出租物若超過合約定立時間，乙方可補收逾時租金。
    CODE
    next_line
  end

  def fourth_code
    text <<-CODE
      第四條∶合約展期
      一、若甲方於合約租期逾時未通知乙方需將合約延展租期，乙方有權利將押金全額沒收。
      二、若甲方需將合約延展租期，乙方有權利決定是否達成合約展期。
    CODE
    next_line
  end

  def fifth_code
    text <<-CODE
      第五條∶租賃點收
      一、甲方應於租賃標的物時當日點收並進行測試，如發現功能不正常或外觀顯有損壞時應即通知乙方，並於當日決定是否承租。
      二、點收完成後之功能不正常、損壞，除因長期累積使用或器材壽命，若由乙方判定是人為損傷造成，一律為甲方之責任，乙方有權利決定要求甲方照合約予以賠償或維修。
    CODE
    next_line
  end

  def sixth_code
    text <<-CODE
      第六條∶返還測試
      乙方應於甲方返還標的物當日進行測試，經乙方測試認可後，方完成返還手續。
    CODE
    next_line
  end

  def seventh_code
    text <<-CODE
      第七條∶所有權
      標的物之所有權歸乙方所有，甲方不得處分標的物或任意拆解、更換零件。
    CODE
    next_line
  end

  def eighth_code
    text <<-CODE
      第八條∶損害賠償
      甲方發現標的物故障等情形時應立即通知乙方，由乙方判斷確認後，若是人為因素造成需維修，乙方視情況有權利決定委託商家維修或要求甲方賠償等值的現金。維修之費用，乙方需出示統一 發票或加蓋店章之維修單據
    CODE
    next_line
  end

  def ninth_code
    text <<-CODE
      第九條∶管轄法院
      雙方如因本合約涉訟，以 #{@item.address} 之地方法院為訴訟第一審管轄法院。
    CODE
    next_line
  end

  def tenth_code
    text <<-CODE
      第十條∶合約收執
      本合約一式兩份，由雙方各收執一份。
    CODE
    next_line
  end

  def eleventh_code
    text <<-CODE
      第十一條∶合約租金 #{@rent_record.price} 元整。
    CODE
    next_line
  end

  def twelfth_code
    text <<-CODE
      第十二條∶合約押金 #{@item.deposit} 元整。
    CODE
    next_line
    start_new_page
  end

  def sign_table
    table sign_content, width: bounds.width, cell_style: { border_width: 0 }
  end

  private

    def date_format(datetime)
      datetime.strftime("西元 %Y 年 %m 月 %d 日 %H 時 %M 分")
    end

    def next_line
      move_down 10
    end

    def sign_content
      [
        ['甲方', '', '乙方', ''],
        ['姓名∶', '', '姓名∶', ''],
        ['身份證字號∶', '', '身份證字號∶', ''],
        ['地址∶', '', '地址∶', ''],
        ['電話∶', '', '電話∶', '']
      ]
    end
end
