crumb :account_customers do
  link t('controller.account/customers.action.index'), account_customers_path
end

crumb :new_account_customer do
  link t('controller.account/customers.action.new'), new_account_customer_path
  parent :account_customers
end

crumb :account_customer do |customer|
  link customer.account, account_customer_path(customer)
  parent :account_customers
end

crumb :edit_account_customer do |customer|
  link t('controller.action.edit'), edit_account_customer_path(customer)
  parent :account_customer, customer
end
