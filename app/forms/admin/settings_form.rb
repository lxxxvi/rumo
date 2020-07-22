class Admin::SettingsForm
  include ActiveModel::Model
  attr_reader :object, :params, :name

  delegate :new_record?, :persisted?, to: :object

  validates :name, presence: true

  def initialize(object, params = {})
    @object = object
    @params = params
    @name = params[:name] || object.name
  end

  def save
    return unless valid?

    object.name = @name

    object.save || copy_error_messages
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Admin::Settings')
  end

  private

  def copy_error_messages
    errors.copy!(object.errors)
    false
  end
end
