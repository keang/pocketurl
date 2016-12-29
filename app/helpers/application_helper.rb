module ApplicationHelper
  def full_url_for(short_url)
    return root_url + short_url.short_path
  end
end
