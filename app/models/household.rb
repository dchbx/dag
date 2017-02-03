class Household < ActiveRecord::Base
  #attr_accessible :name, :household_members_attributes
  has_many :household_members
  accepts_nested_attributes_for :household_members, allow_destroy: true

  RELATIONSHIP_INVERSE_KINDS = { mother: :child, 
                                father: :child, 
                                uncle: :no_relation, 
                                aunt: :no_relation,
                                spouse: :spouse,
                                child: :parent,
                                unrelated: :unrelated,
                                grandchild: :grandparent,
                                aunt_uncle: :niece_nephew,
                                niece_nephew: :aunt_uncle,
                                grandparent: :grandchild }

  after_initialize do |household|
    @household_members ||= {}
  end

  def add_household_member(household_member)
    @household_members[household_member[:name]] = household_member
  end

  def add_relationship(predecessor_name, successor_name, relationship_kind)
    @household_members[predecessor_name].add_relationship(@household_members[successor_name], relationship_kind) if @household_members[successor_name].present? #condition to ignore the first applicant (Mike)
  end

  # def [](name)
  #   @household_members[name]
  # end

  def build_families
    household_members.each do |member|
      if RELATIONSHIP_INVERSE_KINDS.keys.include?(relationship_kind)
      else
      end
    end
  end

  def primaries
    household_members.where(is_primary: true)
  end
end
