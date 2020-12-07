class Admin::DownloadForm
  include ActiveModel::Model

  attr_reader :selected_date

  validate :valid_date

  def initialize(host, params = {})
    @host = host
    @selected_date = params[:selected_date]
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Admin::Download')
  end

  def visits_to_download?
    date_select_options.any?
  end

  def date_select_options
    @date_select_options ||= GroupVisitsByDateService.new(@host).visits_by_date.map do |visit_by_date|
      [
        "#{visit_by_date.date} (#{I18n.t('visits', count: visit_by_date.number_of_visits)})",
        visit_by_date.date.to_s(:db)
      ]
    end
  end

  def validated_selected_date
    @validated_selected_date ||= Date.parse(@selected_date)
  rescue Date::Error
    nil
  end

  def valid_date
    return if validated_selected_date.present?

    errors.add(:selected_date, 'is invalid')
  end
end
