class OrderLendersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :order
  load_and_authorize_resource :order_lender, through: :order

  def show
    respond_to do |format|
      format.pdf do
        pdf = OrderLenderPdf.new(@order_lender)
        send_data pdf.render,
                  filename: t('helpers.records.show.pdf.file_name',
                              name: @order_lender.lender.logo_name,
                              order_id: @order_lender.order_id),
                  type: 'application/pdf;charset=utf-8',
                  disposition: :inline
      end
    end
  end
end
