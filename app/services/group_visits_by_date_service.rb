class GroupVisitsByDateService
  VisitsByDateRow = Struct.new(:data) do
    def date
      Date.parse(data['date'])
    end

    def number_of_visits
      data['number_of_visits']
    end
  end

  def initialize(host)
    @host = host
  end

  def visits_by_date
    @visits_by_date ||= fetch_rows.map do |row|
      VisitsByDateRow.new(row)
    end
  end

  private

  def fetch_rows
    ActiveRecord::Base.connection.execute(group_visits_by_date_sql)
  end

  def group_visits_by_date_sql
    <<~SQL.squish
      WITH host AS (
        SELECT *
          FROM hosts
         WHERE id = #{@host.id}
      )

      , host_visits AS (
        SELECT v.*
          FROM host h
         INNER JOIN visits v ON v.host_id = h.id
      )

      , with_host_visits_in_tz AS (
        SELECT v.*
             , v.visited_at AT TIME ZONE 'UTC' AT TIME ZONE h.country_time_zone_identifier AS visited_at_in_tz
          FROM host_visits v
          CROSS JOIN host h
      )

      , with_host_visits_in_tz_grouped AS (
        SELECT date(visited_at_in_tz) AS date
             , count(*)               AS number_of_visits
          FROM with_host_visits_in_tz
         GROUP BY date(visited_at_in_tz)
         ORDER BY date(visited_at_in_tz) ASC
      )

      SELECT *
        FROM with_host_visits_in_tz_grouped
    SQL
  end
end
