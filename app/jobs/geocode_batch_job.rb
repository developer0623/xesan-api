class GeocodeBatchJob

  def state(provider)
    s = provider[:location_address_state_name]
    s = '' if s == "N/A"
    s
  end

  def logger
    @logger ||= Delayed::Worker.logger
  end

  def address(provider)
    URI.escape(
      provider[:first_line_location_address] + ' ' +
      provider[:location_address_city_name] + ', ' +
      state(provider) + ' ' +
      provider[:location_address_postal_code]
    )
  end

  def address2(provider)
    URI.escape(
      provider[:second_line_location_address] + ' ' +
      provider[:location_address_city_name] + ', ' +
      state(provider) + ' ' +
      provider[:location_address_postal_code]
    )
  end

  def save(provider, response)
    location = JSON.parse(response.body)["result"]["location"]
    lat = location["lat"]
    lon = location["lon"]
    point = %Q{POINT(#{lon} #{lat})}
    provider.geo = point
    provider.save
  end

  def perform(npis)
    aws_host = ENV['GEOCODE_HOST']

    Provider.where(npi: npis).each do |provider|
      begin
        url = "#{aws_host}/geocode/#{address(provider)}"
        response = HTTParty.get(url)

        case response.code.to_i
        when 200
          save(provider, response)
        when 404
          url = "#{aws_host}/geocode/#{address2(provider)}"
          response = HTTParty.get(url)
          if (response.code.to_i == 200)
            save(provider, response)
          else
            logger.error("#{provider.npi} : #{url} => #{response.code}")
          end
        else
          logger.error("#{provider.npi} : #{url} => #{response.code}")
        end
      rescue Exception => e
        logger.error("#{provider.npi} : #{url} => #{e}")
      end
    end
  end
end
