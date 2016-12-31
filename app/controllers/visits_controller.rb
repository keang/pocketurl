class VisitsController < ApplicationController
  def new
    cookies[:user] ||= SecureRandom.uuid
    short_url.visits.create(ip: request.remote_ip,
                            user_agent: request.user_agent,
                            referrer: request.referrer,
                            uid: cookies[:user],
                            created_at: Time.now)
    redirect_to short_url.original_url
  end

  private
  def short_url
    @short_url ||= ShortUrl.find_by(short_path: params[:short_path])
  end
end
