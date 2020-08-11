class ApplicationController < ActionController::Base
  rescue_from Exceptions::RecordNotFound, with: :render_not_found
  rescue_from Exceptions::BadRequest, with: :render_bad_request

  private

  def render_not_found
    render(file: "#{Rails.root}/public/404", layout: true, status: :not_found)
  end

  def render_bad_request
    render(file: "#{Rails.root}/public/400", layout: true, status: :bad_request)
  end
end
