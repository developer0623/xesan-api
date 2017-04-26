class ImportProvidersJob < ActiveJob::Base
  queue_as :default

  def perform(npi_file, chunk_size = 2000)
    chunk_size = chunk_size.to_i

    headers = nil
    File.open(npi_file, "r") do |file|
      headers = file.readline.chomp.split(/","/).map do |header|
        header = header.gsub(/["().]/, '')
        header.gsub(/\s+/, '_').downcase.to_sym
      end
    end

    dir = File.dirname(npi_file)
    Dir.chdir(dir) do
      puts("Splitting #{npi_file} into #{chunk_size} line chunks")
      split = `tail -n +2 #{npi_file} | split -l #{chunk_size} -a 10 - provider_`
      Dir.glob("provider_*") do |file|
        new_file = File.join(dir, file)
        ImportProvidersRawJob.new.delay.perform(new_file, headers)
      end
    end
  end
end
