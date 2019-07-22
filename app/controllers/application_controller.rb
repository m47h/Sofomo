class ApplicationController < ActionController::API
  include JsonWebToken
  include Response

  def authorize_request
    header = request.headers['Authorization']
    raise 'Authorization Header missing' unless header.present?

    header = header.split(' ').last
    token = jwt_decode(header)
    @current_user ||= User.find_by(email: token[:email])
  rescue Exception => e
    error_response(e.message, :unauthorized)
  end
end
