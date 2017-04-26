require 'zip'
require 'csv'

class ImportGeonamesJob < ActiveJob::Base
  queue_as :default

  def headers
    [
      :zip,
      :city,
      :state,
      :county,
      :lonlat
    ]
  end

  def perform(batch_size = 2000)

    batch_size = batch_size.to_i
    file = Tempfile.new('geonames')
    file.binmode
    puts(file.path)
    begin
      puts("Downloading US geonames zip file...")
      start = Time.now
      file.write(HTTParty.get("http://download.geonames.org/export/zip/US.zip").parsed_response)
      puts("Downloaded in #{Time.now - start}s")

      file.rewind
      puts("Unzipping...")
      Zip::File.open(file) do |zip_file|

        puts("Loading...")
        # Find specific entry
        entry = zip_file.glob('US.txt').first
        csv = CSV.new(entry.get_input_stream, {col_sep: "\t"})

        start = Time.now

        while !csv.eof?
          i = 0
          values = []

          while i < batch_size && !csv.eof
            row = csv.shift

            zip = row[1]
            city = row[2]
            state = row[3]
            county = row[4]
            lat = row[9]
            lng = row[10]

            values.push([
              zip,
              city,
              state,
              county,
              %Q{POINT(#{lng} #{lat})}
            ])
            i += 1
          end

          Geoname.import(headers, values, validate: false) if values.length > 0
        end
        puts("Completed Import in #{Time.now - start}s")
      end
    ensure
      file.close
      file.unlink
    end
  end
end
