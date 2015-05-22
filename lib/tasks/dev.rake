namespace :dev do
  desc "rebuild project"
  task rebuild: [ "tmp:clear", "log:clear", "db:drop", "db:create", "db:migrate", "db:seed" ]
end
