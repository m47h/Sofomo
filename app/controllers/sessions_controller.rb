class SessionsController < ApplicationController
  before_action :authorize_request, except: [:login]

  def login
    user = User.find_by(email: params[:email])
    return head :unauthorized unless user && user.authenticate(params[:password])
    json_response(token: jwt_encode({email: user.email}))
  end
end
