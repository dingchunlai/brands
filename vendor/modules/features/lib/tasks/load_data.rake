namespace :features do
  desc '从指定的yaml文件中读取公司数据，并保存。通过DATA来指定文件。'
  task :load_data => :environment do
    if ENV['DATA'].blank?
      puts 'Usage: rake features:load_data DATA=path/to/file'
    else
      Features::PromotedCompany.load_data_from_yaml File.read(ENV['DATA'])
    end
  end
end
