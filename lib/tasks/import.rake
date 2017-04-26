namespace :import do

  desc "Import Geonames data"
  task :geonames, [:chunk_size] => [:environment] do |t, args|
    puts "Importing Geonames data into the #{Rails.env} db"
    ImportGeonamesJob.perform_later(args[:chunk_size])
  end

  desc "Import Providers data"
  task :providers, [:file, :chunk_size] => [:environment] do |t, args|
    puts "Importing Provider data into the #{Rails.env} db"
    ImportProvidersJob.perform_later(args[:file], args[:chunk_size])
  end

  desc "Import NDC product and package data"
  task :ndc, [:chunk_size] => [:environment] do |t, args|
    puts "Importing NDC data into the #{Rails.env} db"
    ImportNdcJob.perform_later(2000) #hard-code 2000 for now
  end

end
