class VisitForm
  include ActiveModel::Model
  attr_reader :object, :params, :name, :contact, :notes, :uuid

  delegate :host, to: :object

  validates :contact, presence: true

  def initialize(object, params = {})
    @object = object
    @params = params
    @name, @contact, @notes, @uuid = params.values_at(:name, :contact, :notes, :uuid)
  end

  def save
    return false unless valid?

    object.attributes = {
      name: name,
      contact: contact,
      notes: notes,
      uuid: uuid
    }

    object.set_confirmed_at if host.auto_confirm_visits?
    object.save!
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Visit')
  end
end
