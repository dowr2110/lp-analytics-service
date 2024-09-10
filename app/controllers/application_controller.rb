class ApplicationController < ActionController::API
  before_action :authenticate

  private

  def authenticate
    provided_token = request.headers['Authorization']
    valid_token = ENV['API_AUTH_TOKEN']
    unless ActiveSupport::SecurityUtils.secure_compare(provided_token || '', valid_token || '')
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end
end
