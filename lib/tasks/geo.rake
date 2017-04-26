namespace :geo do
  desc "Start Geocoding"
  task :go => [:environment] do
    puts "Geocoding providers"
    GeocodeProvidersJob.perform_later(ENV['batch'])
  end

  desc "Count remaining items to geocode"
  task :count => [:environment] do
    where_clause = %Q{geo is NULL}
    where_clause << %Q{ AND location_address_state_name = '#{ENV['state']}'} if ENV['state']
    puts("count: #{Provider.where(where_clause).count}")
  end
end
