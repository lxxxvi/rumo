require 'csv'

class VisitsDownloadService
  def initialize(host, date)
    @host = host
    @date = date
  end

  def to_csv
    @to_csv ||= create_csv
  end

  def filename
    "visits_#{@date}.csv"
  end

  private

  def create_csv
    CSV.generate do |csv|
      csv << ['Visited at', 'Token', 'Name', 'Contact', 'Notes', 'Visit Confirmed At']
      visits.map do |visit|
        csv << [visit.visited_at, visit.token, visit.name, visit.contact, visit.notes, visit.confirmed_at]
      end
    end
  end

  def visits
    mark_visits_as_downloaded!
    scope
  end

  # rubocop:disable Rails/SkipsModelValidations
  def mark_visits_as_downloaded!
    scope.where(downloaded_at: nil).update_all(downloaded_at: Time.zone.now)
  end
  # rubocop:enable Rails/SkipsModelValidations

  def scope
    @scope ||= @host.visits.visited_at_on_date_in_time_zone(@date, @host.country_time_zone_identifier)
  end
end
