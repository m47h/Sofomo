require 'test_helper'
require 'minitest/autorun'

class GeolocationsControllerTest < ActionDispatch::IntegrationTest
  include JsonWebToken

  setup do
    @geolocation = geolocations(:one)
    @user = User.create(email: 'test@sofomo.com', password: 'Password1')
    @ip_or_hostname = '8.8.8.8'
  end

  test 'when header is missing should response unauthorized' do
    get geolocation_path, headers: {}, as: :json

    assert_equal JSON.parse(response.body)['errors'], 'Authorization Header missing'
    assert_response :unauthorized
  end

  test 'when token is wrong should response unauthorized' do
    get geolocation_path, headers: { 'Authorization': 'Bearer wrong_token' }, as: :json

    assert_equal JSON.parse(response.body)['errors'], 'Not enough or too many segments'
    assert_response :unauthorized
  end

  test 'when Geoip::NotFound should return not_found' do
    stub_request(:any, 'https://freegeoip.app/json/' + @ip_or_hostname).to_raise(Geoip::NotFound)
    post(
      geolocations_url,
      params: { ip_or_hostname: @ip_or_hostname },
      headers: authorization_token,
      as: :json,
    )

    assert_response :not_found
  end

  test 'when Geoip timeout should return not_found' do
    stub_request(:any, 'https://freegeoip.app/json/' + @ip_or_hostname).to_timeout
    post(
      geolocations_url,
      params: { ip_or_hostname: @ip_or_hostname },
      headers: authorization_token,
      as: :json,
    )

    assert_response :request_timeout
  end

  test 'when geolocation already exist should response unprocessable_entity' do
    stub_geoip_request('123.123.123.123')
    post(
      geolocations_url,
      params: { ip_or_hostname: '123.123.123.123' },
      headers: authorization_token,
      as: :json,
    )

    assert_equal JSON.parse(response.body)['errors'], { 'ip_or_hostname' => ['has already been taken'] }
    assert_response :unprocessable_entity
  end

  test 'should create geolocation' do
    stub_geoip_request(@ip_or_hostname)
    assert_difference('Geolocation.count', 1) do
      post(
        geolocations_url,
        params: { ip_or_hostname: @ip_or_hostname },
        headers: authorization_token,
        as: :json,
      )
    end

    assert_response :created
  end

  test 'should show geolocation' do
    get geolocation_path, headers: authorization_token, as: :json

    assert_response :ok
  end

  test 'when ActiveRecord::RecordNotFound should return not_found' do
    @geolocation = OpenStruct.new(ip_or_hostname: 'wrong_ip_or_hostname')
    get geolocation_path, headers: authorization_token, as: :json

    assert_response :not_found
  end

  test 'when ActiveRecord::ConnectionTimeoutError should use Geoip' do
    stub_geoip_request('123.123.123.123')
    timeout_error = ->(ip_or_hostname){ raise ActiveRecord::ConnectionTimeoutError }

    Geolocation.stub :find_by!, timeout_error do
      get geolocation_path, headers: authorization_token, as: :json

      assert_equal(response.body, '{"latitude":37.751,"longitude":-97.822,"ip_or_hostname":"123.123.123.123"}')
      assert_response :ok
    end
  end

  test 'should destroy geolocation' do
    assert_difference('Geolocation.count', -1) do
      delete geolocation_path, headers: authorization_token, as: :json
    end

    assert_response :no_content
  end

  test 'when ActiveRecord::RecordNotFound should not destroy geolocation and return not_found' do
    @geolocation = OpenStruct.new(ip_or_hostname: 'wrong_ip_or_hostname')
    assert_difference('Geolocation.count', 0) do
      delete geolocation_path, headers: authorization_token, as: :json
    end

    assert_response :not_found
  end

  test 'when ActiveRecord::ConnectionTimeoutError should return databse_timeout' do
    timeout_error = ->(ip_or_hostname){ raise ActiveRecord::ConnectionTimeoutError }

    Geolocation.stub :find_by!, timeout_error do
      delete geolocation_path, headers: authorization_token, as: :json

      assert_response :request_timeout
    end
  end

  private

  def geolocation_path
    '/geolocations/' + @geolocation.ip_or_hostname
  end

  def authorization_token
    { 'Authorization': 'Bearer ' + jwt_encode({ user_email: @user.email }) }
  end

  def stub_geoip_request(ip_or_hostname)
    stub_request(:get, 'https://freegeoip.app/json/' + ip_or_hostname).
      with(headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' }).
      to_return(
        status: 200,
        body: '{"ip":"' + ip_or_hostname + '","latitude":37.751,"longitude":-97.822}',
        headers: { 'Content-Type': 'application/json' },
      )
  end
end

