class Admin::SettingsForm
  include ActiveModel::Model
  attr_reader :object, :params, :name, :url_identifier

  delegate :new_record?, :persisted?, to: :object

  validates :url_identifier,
            format: { with: /\A([a-zA-Z0-9-])*\z/, message: 'may only contain alphanumeric characters and dashes' }

  def initialize(object, params = {})
    @object = object
    @params = params
    @name = params[:name] || object.name
    @url_identifier = params[:url_identifier] || object.url_identifier
  end

  def save
    return unless valid?

    object.name = name
    object.url_identifier = url_identifier

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
