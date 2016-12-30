class ShortUrlsController < ApplicationController
  def new; end

  def create
    short_url = ShortUrl.new(short_url_params)
    if short_url.save
      redirect_to short_url
    else
      render 'new'
    end
  end

  def show
    @short_url = ShortUrl.find params[:id]
  end

  private

  def short_url_params
    params.require(:short_url).permit(:original_url)
  end
end
