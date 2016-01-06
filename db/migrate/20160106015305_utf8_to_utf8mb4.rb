class Utf8ToUtf8mb4 < ActiveRecord::Migration
  TABLE_COL_PAIRS = {
    items: :description,
    profiles: :description
  }

  def up
    execute "ALTER DATABASE `#{ActiveRecord::Base.connection.current_database}` CHARACTER SET utf8mb4"

    ActiveRecord::Base.connection.tables.each do |table|
      execute "ALTER TABLE `#{table}` CHARACTER SET = utf8mb4"
    end

    TABLE_COL_PAIRS.each do |table, col|
      execute "ALTER TABLE `#{table}` CHANGE `#{col}` `#{col}` TEXT  CHARACTER SET utf8mb4  NULL"
    end
  end

  def down
    execute "ALTER DATABASE `#{ActiveRecord::Base.connection.current_database}` CHARACTER SET utf8"

    ActiveRecord::Base.connection.tables.each do |table|
      execute "ALTER TABLE `#{table}` CHARACTER SET = utf8"
    end

    TABLE_COL_PAIRS.each do |table, col|
      execute "ALTER TABLE `#{table}` CHANGE `#{col}` `#{col}` TEXT  CHARACTER SET utf8  NULL"
    end
  end
end
