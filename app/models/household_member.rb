class HouseholdMember

  attr_reader :name

  RELATIONSHIP_KINDS = %w(spouse mother father child unrelated)

  field :family_member_id, type: BSON::ObjectId

  def initialize(name)
    @name = name
    @successors = []
  end

  def add_relationship(successor, relationship_kind)
    @successors << successor
  end

  def to_s
    "#{@name} -> [#{@successors.map(&:name).join(' ')}]"
  end


end
