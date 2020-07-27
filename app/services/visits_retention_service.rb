module VisitsRetentionService
  module_function

  RETENTION_PERIOD = 14.days.freeze

  def remove_expired!
    Visit.where('visited_at < :time', time: retention_time).delete_all
  end

  def retention_time
    Time.zone.now - RETENTION_PERIOD
  end
end
