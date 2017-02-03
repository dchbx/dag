class NewHouseholdForm
  include ActiveModel::Model
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  attr_accessor :name, :id

  def save
    household = Household.create
    @id = household.id
    @persisted = true
    HouseholdMember.create(household: household, is_primary: true, name: name)
  end

  def model_name
    ActiveModel::Name.new(Household)
  end

  def persisted?
    @persisted ||= false
  end
end
