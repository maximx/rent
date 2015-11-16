crumb :dashboard_customers do
  link '客戶列表', dashboard_customers_path
end

crumb :new_dashboard_customer do
  link '新增客戶', new_dashboard_customer_path
  parent :dashboard_customers
end

crumb :dashboard_customer do |customer|
  link customer.account, dashboard_customer_path(customer)
  parent :dashboard_customers
end

crumb :edit_dashboard_customer do |customer|
  link '修改', edit_dashboard_customer_path(customer)
  parent :dashboard_customer, customer
end
