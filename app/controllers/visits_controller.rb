class VisitsController < ApplicationController
  def new
    cookies[:user] ||= SecureRandom.uuid
    redirect_to short_url.original_url
  end

  private
  def short_url
    @short_url ||= ShortUrl.find_by(short_path: params[:short_path])
  end
end
