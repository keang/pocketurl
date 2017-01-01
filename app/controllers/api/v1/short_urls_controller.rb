class Api::V1::ShortUrlsController < ApplicationController

  def show
    render json: ShortUrlStats.for(current_short_url)
  end

  private
  def current_short_url
    @short_url ||= ShortUrl.where(short_path: params[:short_path]).
                     or(ShortUrl.where(original_url: params[:original_url])).
                     first!
  end
end
