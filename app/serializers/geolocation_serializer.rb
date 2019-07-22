class GeolocationSerializer < ActiveModel::Serializer
  attributes :ip_or_hostname,
             :country_code,
             :country_name,
             :region_code,
             :region_name,
             :city,
             :zip_code,
             :time_zone,
             :latitude,
             :longitude,
             :metro_code
end



