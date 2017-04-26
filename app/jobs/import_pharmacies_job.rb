require 'csv'

class ImportPharmaciesJob < ActiveJob::Base
  queue_as :default

  def perform(file_location, batch_size = 1000)
    csv = CSV.open(file_location, :headers => true, :header_converters => :symbol)

    while !csv.eof?
      start = Time.now
      i = 0

      ActiveRecord::Base.transaction do
        i = 0
        while i < batch_size && !csv.eof
          row = csv.shift

          if row[:e_state] == "FL"
            Pharmacy.find_or_initialize_by(id: row[:id].to_i) do |p|
              p.update({
              npi: row[:p_medcare],
              name: row[:biz_name],
              address: row[:e_address],
              city: row[:e_city],
              state: row[:e_state],
              zip: row[:e_postal],
              lonlat: %Q{POINT(#{row[:loc_long_poly]} #{row[:loc_lat_poly]})},
              phone: row[:biz_phone]
              })
            end
            i += 1
          end
        end
      end

      puts("Completed #{i} in #{Time.now - start}")
    end

    # CSV.foreach(file_location, headers: :first_row) do |row|

    #   if row['e_state'] == "FL"
    #     Pharmacy.create({
    #       npi: row['p_medcare'],
    #       name: row['biz_name'],
    #       address: row['e_address'],
    #       city: row['e_city'],
    #       state: row['e_state'],
    #       postal: row['e_postal'],
    #       lonlat: %Q{POINT(#{row['loc_LONG_centroid']} #{row['loc_LAT_centroid']})},
    #       phone: row['biz_phone']
    #       })
    #   end

      # next if row['Provider Business Practice Location Address Postal Code'] != "32092"

      # next if row['Provider Business Practice Location Address State Name'] != "FL" || row['Entity Type Code'] != "2"
      # # puts row['Entity Type Code'] == "2"
      # is_pharmacy = false
      # (1..15).each do |num|
      #   if ['333600000X', '3336C0003X'].include?(row["Healthcare Provider Taxonomy Code_#{num}"])
      #     is_pharmacy = true
      #     break
      #   end
      # end
      # # puts(row) if is_pharmacy
      # if is_pharmacy
      #   zip = row['Provider Business Practice Location Address Postal Code'][0..4]

      #   gn = Geoname.select(:lonlat).where(zip: zip).first
      #   lonlat = gn.lonlat if gn
      #   # puts lonlat

      #   Pharmacy.create({
      #     npi: row['NPI'],
      #     name: row['Provider Other Organization Name'] || row['Provider Organization Name (Legal Business Name)'],
      #     address: row['Provider First Line Business Practice Location Address'],
      #     city: row['Provider Business Practice Location Address City Name'],
      #     state: row['Provider Business Practice Location Address State Name'],
      #     postal: row['Provider Business Practice Location Address Postal Code'],
      #     phone: row['Provider Business Practice Location Address Telephone Number'],
      #     lonlat: lonlat
      #   })
      # end
        # lonlat: %Q{POINT(#{row['loc_LONG_centroid']} #{row['loc_LAT_centroid']})},
    # end
  end
end
