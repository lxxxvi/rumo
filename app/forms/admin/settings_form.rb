class Admin::SettingsForm
  include ActiveModel::Model
  attr_reader :object, :params, :name, :url_identifier, :auto_confirm_visits, :notes_enabled

  delegate :new_record?, :persisted?, to: :object

  validates :url_identifier,
            format: { with: /\A([a-zA-Z0-9-])*\z/, message: 'may only contain alphanumeric characters and dashes' }

  def initialize(object, params = {})
    @object = object
    @params = params
    @name = params[:name] || object.name
    @url_identifier = params[:url_identifier] || object.url_identifier
    @auto_confirm_visits = params[:auto_confirm_visits] || object.auto_confirm_visits
    @notes_enabled = params[:notes_enabled] || object.notes_enabled
  end

  def save
    return unless valid?

    object.name = name
    object.url_identifier = url_identifier
    object.auto_confirm_visits = auto_confirm_visits
    object.notes_enabled = notes_enabled

    object.save || copy_error_messages
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Admin::Settings')
  end

  def calculated_visit_url
    Host.new(url_identifier: url_identifier).visit_url
  end

  private

  def copy_error_messages
    errors.copy!(object.errors)
    false
  end
end
