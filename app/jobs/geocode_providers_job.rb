class GeocodeProvidersJob < ActiveJob::Base
  queue_as :default

  def perform(chunk_size = 1000)
    chunk_size = chunk_size.to_i

    puts("chunk_size: #{chunk_size}")
    if ENV['where']
      where_clause = ENV['where']
    else
      where_clause = %Q{geo is NULL}
      where_clause += %Q{ AND location_address_state_name = '#{ENV['state']}'} if ENV['state']
    end

    puts("q: #{where_clause}")
    count = Provider.where(where_clause).count

    puts("count: #{count}")
    (0..count-1).step(chunk_size).each do |c|
      puts("batch: #{c}")
      npis = Provider.select(:npi).where(where_clause).limit(chunk_size).offset(c).map { |p| p[:npi] }
      GeocodeBatchJob.new.delay.perform(npis)
      # GeocodeBatchJob.new.perform(npis)
    end
  end
end
