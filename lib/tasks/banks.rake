namespace :banks do
  task :seeds => :environment do
    bank_code_name_list = []

    file_path = Rails.root.join('config', 'initializers', 'bank_list.txt')
    File.open( file_path ) do |f|
      code = ''
      name = ''

      f.each_line do |line|
        if /[0-9]{3}/.match line
          code = line.chop
        else
          name = line.gsub('　', '').strip
          bank_code_name_list << { code: code, name: name }
        end
      end
    end

    bank_code_name_list.each do |code_name_params|
      bank_code = Bank.new( code_name_params )
      bank_code.save
    end
  end
end
