module ProviderQueryable
  extend ActiveSupport::Concern

  def index
    zip = params[:zip]
    latlon = params[:latlon]
    within = params[:within].to_f || 10.0
    query = params[:q]
    doctor_patient_id = params[:doctor_patient_id]
    pharmacy_patient_id = params[:pharmacy_patient_id]
    limit = params[:limit]

    if zip
      gn = Geoname.where(zip: zip).first
      if gn && gn.lonlat
        point = gn.lonlat.to_s
      end
    elsif latlon
      lat, lon = latlon.split(',').map { |x| x.to_f }
      point = %Q{POINT(#{lon} #{lat})}
    end

    selects = ["*"]
    wheres = []
    params = {}
    if query
      wheres.push(%Q{
        lower(first_name) LIKE :query OR
        lower(middle_name) LIKE :query OR
        lower(last_name) LIKE :query OR
        lower(first_name) || ' ' || lower(middle_name) || ' ' || lower(last_name) || ' ' || lower(location_address_city_name) || ' ' || lower(location_address_state_name) LIKE :query OR
        lower(organization_name) LIKE :query OR
        lower(other_organization_name) LIKE :query OR
        lower(second_line_location_address) LIKE :query OR
        lower(first_line_location_address) LIKE :query OR
        lower(location_address_city_name) LIKE :query OR
        lower(location_address_state_name) LIKE :query OR
        location_address_postal_code LIKE :query OR
        location_address_telephone_number LIKE :query
      })

      params[:query] = %Q{%#{query.downcase}%}
    end

    if point
      meters = 1609.34 * within
      selects.push(%Q{ST_Distance(geo, ST_Geomfromtext('#{point}')) as distance})
      wheres.push(%Q{ST_DWithin(geo, '#{point}', #{meters})})
    end

    if doctor_patient_id
      selects.push(%Q{(SELECT COUNT(*) FROM medications m WHERE m.prescriber_id = npi and m.user_id = #{doctor_patient_id} LIMIT 1) AS is_patient_doctor})
    end

    if pharmacy_patient_id
      selects.push(%Q{(SELECT COUNT(*) FROM medications m WHERE m.pharmacy_id = npi and m.user_id = #{pharmacy_patient_id} LIMIT 1) AS is_patient_pharmacy})
    end

    @providers = model_class.select(selects.join(', ')).where(wheres.join(' AND '), params)
    #AL: this can be done differently and I will revisit when doing tune-up.
    @providers = @providers.order("is_patient_doctor DESC, first_name, last_name") if doctor_patient_id
    @providers = @providers.order("is_patient_pharmacy DESC, organization_name") if pharmacy_patient_id
    @providers = @providers.order("distance") if point
    @providers = @providers.limit(limit) if limit

    render json: @providers
  end

  def show
    @provider = model_class.find(params[:id])
    render json: @provider
  end

  def model_class
    controller_name.classify.constantize
  end

end
