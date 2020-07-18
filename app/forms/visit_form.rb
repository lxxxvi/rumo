class VisitForm
  include ActiveModel::Model
  attr_reader :object, :params, :name, :contact, :uuid

  delegate :host, to: :object

  validates :contact, presence: true

  def initialize(object, params = {})
    @object = object
    @params = params
    @name, @contact, @uuid = params.values_at(:name, :contact, :uuid)
  end

  def save
    return false unless valid?

    object.attributes = {
      name: name,
      contact: contact,
      uuid: uuid
    }
    object.save!
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Visit')
  end
end
