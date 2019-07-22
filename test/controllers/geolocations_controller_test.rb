require 'test_helper'

class GeolocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @geolocation = geolocations(:one)
  end

  test "should get index" do
    get geolocations_url, as: :json
    assert_response :success
  end

  test "should create geolocation" do
    assert_difference('Geolocation.count') do
      post geolocations_url, params: { geolocation: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show geolocation" do
    get geolocation_url(@geolocation), as: :json
    assert_response :success
  end

  test "should update geolocation" do
    patch geolocation_url(@geolocation), params: { geolocation: {  } }, as: :json
    assert_response 200
  end

  test "should destroy geolocation" do
    assert_difference('Geolocation.count', -1) do
      delete geolocation_url(@geolocation), as: :json
    end

    assert_response 204
  end
end
