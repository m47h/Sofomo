class Geolocation < ApplicationRecord
  validates :ip_or_hostname, presence: true, uniqueness: true
end
