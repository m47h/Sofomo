module JsonWebToken
  HMAC_SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def jwt_encode(payload, exp = 1.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, HMAC_SECRET_KEY)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, HMAC_SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
