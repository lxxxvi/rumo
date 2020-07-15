class VisitsStatisticsService
  def initialize(host)
    @host = host
  end

  def statistics
    @statistics ||= sql_result.reduce({}) do |result, item|
      result.merge(Hash[item['status'], item['visit_count']])
    end
  end

  private

  def sql_result
    @sql_result ||= Visit.connection.execute(statistics_sql)
  end

  def statistics_sql
    <<~SQL
      WITH visits_status AS (
        SELECT CASE
                 WHEN confirmed_at IS NULL THEN 'unconfirmed' ELSE 'confirmed'
               END status
          FROM visits
         WHERE host_id = #{@host.id}
       )
       SELECT status
            , count(*) AS visit_count
         FROM visits_status
         GROUP BY status
    SQL
  end
end
