module Response
  def json_response(json, status = :ok)
    render json: json, status: status
  end
end
