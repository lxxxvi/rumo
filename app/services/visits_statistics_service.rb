class VisitsStatisticsService
  Statistics = Struct.new(:data) do
    def confirmed
      data[:confirmed] || 0
    end

    def unconfirmed
      data[:unconfirmed] || 0
    end
  end

  def initialize(host)
    @host = host
  end

  def statistics
    @statistics ||= Statistics.new(sql_result_as_hash)
  end

  private

  def sql_result_as_hash
    sql_result.reduce({}) do |result, item|
      result.merge(Hash[item['status'], item['visit_count']])
    end.deep_symbolize_keys
  end

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
