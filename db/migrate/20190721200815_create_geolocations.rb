class CreateGeolocations < ActiveRecord::Migration[5.2]
  def change
    create_table :geolocations do |t|
      t.string :ip_or_hostname
      t.string :country_code
      t.string :country_name
      t.string :region_code
      t.string :region_name
      t.string :city
      t.string :zip_code
      t.string :time_zone
      t.string :latitude
      t.string :longitude
      t.string :metro_code

      t.timestamps
    end
  end
end
