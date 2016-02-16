namespace :once do
  task :build_user_deliver => :environment do
    users = User.all
    delivers = Deliver.where(id: [1, 2])
    users.each do |user|
      user.delivers << delivers if user.delivers.empty?
    end
  end

  task :add_send_home_deliver => :environment do
    Deliver.create(name: '送貨到府(限臺南)')
    deliver = Deliver.find 1
    deliver.update remit_needed: true, delivery_needed: true
    deliver = Deliver.find 2
    deliver.update address_needed: false
  end

  task :recreate_record_address => :environment do
    records = Record.all
    records.each do |record|
      record.address = if record.deliver.address_needed?
                         record.borrower.profile.address
                       else
                         record.lender.profile.address
                       end
      record.save
    end
  end

  task :create_order_lender => :environment do
    Order.all.each do |order|
      order.records.group_by(&:lender).each do |lender, records|
        record = records.first
        lender_price, lender_deposit, lender_deliver_fee = 0, 0, 0

        order_lender = order.order_lenders.create(
          lender:     lender,
          aasm_state: record.aasm_state,
          deliver_id: record.deliver_id
        )

        records.each do |record|
          record.update(order_lender: order_lender)
          lender_price       += record.price
          lender_deposit     += record.item_deposit
          lender_deliver_fee += record.deliver_fee
        end

        order_lender.update(
          price:       lender_price,
          deposit:     lender_deposit,
          deliver_fee: lender_deliver_fee
        )
      end
    end
  end

  task :create_order_lender_log => :environment do
    OrderLender.all.each do |order_lender|
      record = order_lender.records.first

      record.record_state_logs.order(:created_at).each do |record_log|
        order_lender_log = order_lender.order_lender_logs.create(
          user:       record_log.borrower,
          aasm_state: record_log.aasm_state,
          info:       record_log.info,
          created_at: record_log.created_at,
          updated_at: record_log.updated_at
        )
      end
    end
  end
end
