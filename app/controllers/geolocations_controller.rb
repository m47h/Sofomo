class GeolocationsController < ApplicationController
  before_action :authorize_request
  before_action :set_geolocation, only: [:show, :destroy]

  def show
    json_response(@geolocation)
  end

  def create
    @geolocation = Geolocation.new(geoip_result)
    return error_response(@geolocation.errors) unless @geolocation.save

    json_response(@geolocation, :created)
  end

  def destroy
    @geolocation.destroy
    head :no_content
  end

  private
    def set_geolocation
      @geolocation = Geolocation.find_by!(ip_or_hostname: permit_params[:ip_or_hostname].downcase)
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end

    def geoip_result
      search_result = Geoip.new.search(permit_params[:ip_or_hostname].downcase)
      search_result[:ip_or_hostname] = permit_params[:ip_or_hostname]
      search_result.delete(:ip)
      search_result
    end

    def permit_params
      params.permit(:ip_or_hostname)
    end
end
