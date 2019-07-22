module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def error_response(errors = nil, status = :unprocessable_entity)
    render json: { errors: errors }, status: status
  end
end
