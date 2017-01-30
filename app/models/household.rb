class Household

  # has_many :household_members

  RELATIONSHIP_INVERSE_KINDS = { mother: :child, father: :child, uncle: :unrelated, aunt: :unrelated }

  def initialize
    @household_members = {}
  end

  def add_household_member(household_member)
    @household_members[household_member.name] = household_member
  end

  def add_relationship(predecessor_name, successor_name)
    @household_members[predecessor_name].add_relationship(@household_members[successor_name])
  end

  def [](name)
    @household_members[name]
  end

  def build_families
    household_members.each do |member|
      if RELATIONSHIP_INVERSE_KINDS.keys.include?(relationship_kind)
      else
      end
    end
  end

end
