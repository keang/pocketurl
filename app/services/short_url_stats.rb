class ShortUrlStats
  def self.for(short_url)
    {
      original_url: short_url.original_url,
      short_path: short_url.short_path,
      visits: visits_summary(short_url.visits),
      devices: devices_data(short_url.visits)
    }
  end

  private
  def self.visits_summary(visits)
    {
      count: visits.count,
      unique_devices_count: visits.pluck(:uid).uniq.count
    }
  end

  def self.devices_data(all_visits)
    all_visits.group_by(&:uid).collect do |uid, user_visits|
      {
        uid: uid,
        ips: user_visits.pluck(:ip),
        user_agents: user_visits.pluck(:user_agent),
        referrers: user_visits.pluck(:referrer)
      }
    end
  end
end
