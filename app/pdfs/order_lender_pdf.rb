class OrderLenderPdf < Prawn::Document
  def initialize(order_lender)
    super()
    @order = order_lender.order
    @borrower_profile = order_lender.borrower.profile
    @lender_profile = order_lender.lender.profile
    @order_lender_records = order_lender.records.includes(:item)

    font_families.update("guangho_chinese" => {
      normal: "#{Rails.root.join("app", "assets", "fonts", "华文仿宋.ttf")}",
      bold: "#{Rails.root.join("app", "assets", "fonts", "华文黑体.ttf")}"
    })
    font "guangho_chinese"

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
    item_table
    lender_borrower_table
    sign_here
  end

  def declare_code
    text '出租合約書', size: 16, align: :center, style: :bold
    move_down 5
    next_line
  end

  def first_code
    text_title      "第一條：租期"
    text_with_space "本合約以標的物驗收手續完成後隔日起租，標的物返還時間以本合約規定為準。"
    text_with_space "自 #{underline_str date_format(@order.started_at)} 起，"\
                    "至 #{underline_str date_format(@order.ended_at)} 止。", inline_format: true
    next_line
  end

  def second_code
    text_title      "第二條：押金、押證件"
    text_with_space "一、甲方承租標的物時，可質押相關證件予乙方或供乙方拍照，亦可按合約規定之金額支付押金。"
    text_with_space "二、甲方質押之證件、押金，於合約終止若無維修等相關問題時，由乙方歸還甲方。否則待維修完成後，再予"
    text_with_space "以歸還。", space: 3
    text_with_space "三、乙方有義務於租約期間保管甲方質押之證件，且不得擅自使用甲方之證件，亦不得直接或間接提供予第三"
    text_with_space "人使用。", space: 3
    next_line
  end

  def third_code
    text_title      "第三條：租賃物返還與違約罰款"
    text_with_space "一、甲方應於本合約屆滿或終止時將標的物返還乙方。"
    text_with_space "二、甲方歸還出租物若超過合約定立時間，乙方可補收逾時租金。"
    next_line
  end

  def fourth_code
    text_title      "第四條：合約展期"
    text_with_space "一、若甲方於合約租期逾時未通知乙方需將合約延展租期，乙方有權利將押金全額沒收。"
    text_with_space "二、若甲方需將合約延展租期，乙方有權利決定是否進行合約展期。"
    next_line
  end

  def fifth_code
    text_title      "第五條∶租賃點收"
    text_with_space "一、甲方應於租賃當日點收並測試，發現功能不正常或外觀損壞時應通知乙方，並於當日決定是否承租。"
    text_with_space "二、點收完成後之功能不正常、損壞，非因長期累積使用或器材壽命，若由乙方判定是人為損傷造成，一律為"
    text_with_space "甲方之責任，乙方有權利決定要求甲方照合約予以賠償或維修。", space: 3
    next_line
  end

  def sixth_code
    text_title      "第六條：返還測試"
    text_with_space "乙方應於甲方返還標的物當日進行測試，經乙方測試認可後，方完成返還手續。"
    next_line
  end

  def seventh_code
    text_title      "第七條：所有權"
    text_with_space "標的物之所有權歸乙方所有，甲方不得處分標的物或任意拆解、更換零件。"
    next_line
  end

  def eighth_code
    text_title      "第八條：損害賠償"
    text_with_space "甲方發現標的物故障等情形時應立即通知乙方，乙方判斷確認，若是人為因素造成損壞，乙方有權利要求甲方"
    text_with_space "賠償。維修之費用，乙方需出示統一發票或加蓋店章之維修單據。"
    next_line
  end

  def ninth_code
    text_title      "第九條：管轄法院"
    text_with_space "雙方如因本合約涉訟，以乙方所在地之地方法院為訴訟第一審管轄法院。"
    next_line
  end

  def item_table
    table item_content,
          cell_style: { border_width: 0.1, size: 10 },
          column_widths: {0 => 70,1 => 220,2 => 60,3 => 60,4 => 60,5 => 70},
          position: :center
  end

  def lender_borrower_table
    table sign_content,
          position: :center,
          width: bounds.width,
          cell_style: { border_width: 0, size: 10 }
    next_line 15
  end

  def sign_here
    text "簽名：#{underline_str}", align: :right
  end

  private
    def text_with_space(string, options = {})
      indent_options = { indent_paragraphs: 11, size: 11 }

      if options.has_key?(:space)
        indent_options[:indent_paragraphs] = 11 * options[:space]
        indent_options.delete :space
      end

      options.reverse_merge! indent_options

      text string, options
    end

    def text_title(string)
      text string, style: :bold
    end

    def date_format(datetime)
      datetime.strftime('西元%Y年%m月%d日')
    end

    def next_line(down_number = 1)
      move_down down_number
    end

    def underline_str(string='')
      string.present? ? "<u>#{string}</u>" : "____________________________"
    end

    def sign_content
      [
        ['', '甲方', '', '乙方'],
        ['姓名：', @borrower_profile.name, '姓名：', @lender_profile.name],
        ['身份證字號：', '', '身份證字號：', ''],
        ['地址：', @borrower_profile.address, '地址：', @lender_profile.address],
        ['電話：', @borrower_profile.phone, '電話：', @lender_profile.phone]
      ]
    end

    def item_content
      content, total_price = [], 0
      content << ['編號', '名稱', "租金", '總租金', '押金', '小計']
      @order_lender_records.each do |record|
        item = record.item
        total_price += record.total_net_price

        content << [
          item.product_id,
          item.name,
          "#{render_currency_money(record.item_price)}/#{record.item_period_i18n}",
          render_currency_money(record.price),
          render_currency_money(record.item_deposit),
          render_currency_money(record.total_net_price)
        ]
      end
      content << ['', '', '', '', '總計', render_currency_money(total_price)]
    end

    def render_currency_money(number)
      ApplicationController.helpers.render_currency_money(number)
    end
end
