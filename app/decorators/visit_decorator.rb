class VisitDecorator < SimpleDelegator
  def display_visited_at_in_hosts_time_zone
    I18n.l(visited_at_in_hosts_time_zone)
  end

  def display_status
    @display_status ||= status.to_s.capitalize
  end

  def visited_at_in_hosts_time_zone
    @visited_at_in_hosts_time_zone ||= visited_at.in_time_zone(host.country_time_zone_identifier)
  end
end
