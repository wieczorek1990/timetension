class RequestsController < ApplicationController
  # POST /
  def root
    params_serializer = RequestsRootParamsSerializer.new params
    unless params_serializer.valid?
      return render json: params_serializer.errors, status: :unprocessable_entity
    end

    ip = request.ip
    now = DateTime.now

    @request = Request.new ip: ip, result: now
    success = save_or_errors @request, :request

    if success and params_serializer.extended?
      request_now = params_serializer.parse_now
      difference = (now - request_now) * 1.seconds

      @difference = Difference.new request_id: @request.id, result: difference
      success = save_or_errors @difference, :difference

      if success
        differences = Difference.joins(:request).where(requests: {ip: ip})
        average_difference = differences.average(:result).to_f
        @response[:average_difference] = average_difference
      end
    end

    if @errors.empty?
      render json: @response, status: :created
    else
      render json: @errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def request_params
      params.permit(:now)
    end
end
