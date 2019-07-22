class GeolocationsController < ApplicationController
  before_action :authorize_request
  before_action :set_geolocation, only: [:show, :destroy]

  def show
    json_response(@geolocation)
  end

  def create
    search_result = geoip.search(params[:ip_or_hostname].downcase)
    return head :not_found if search_result[:error].present?

    search_result[:ip_or_hostname] = params[:ip_or_hostname]
    search_result.delete(:ip)
    @geolocation = Geolocation.new(search_result)
    if @geolocation.save
      json_response(@geolocation, :created)
    else
      json_response(@geolocation.errors, :unprocessable_entity)
    end
  end

  def destroy
    @geolocation.destroy
    head :ok
  end

  private
    def set_geolocation
      @geolocation = Geolocation.find_by!(ip_or_hostname: params[:ip_or_hostname].downcase)
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end

    def permit_params
      params.permit(:ip_or_hostname)
    end

    def geoip
      @geoip ||= Geoip.new
    end
end
