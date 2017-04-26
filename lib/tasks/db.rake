namespace :db do

  desc "Reset the xenapi database"
  task :reset => ["drop", "create", "migrate", :environment] do
    puts "Resetting the #{Rails.env} db"
  end

  # Run a custom seed file from db/seeds/filename
  namespace :seed do
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb').intern
      task task_name => :environment do
        load(filename) if File.exist?(filename)
      end
    end
  end

end
