class Admin::VisitForm
  include ActiveModel::Model

  attr_reader :object, :notes

  delegate :persisted?, :to_param, to: :object

  def initialize(object, params = {})
    @object = object
    @notes = params[:notes] || @object.notes
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Admin::Visit')
  end

  def save
    @object.notes = notes
    @object.set_confirmed_at
    @object.save!
  end
end
