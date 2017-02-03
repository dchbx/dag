class HouseholdMember < ActiveRecord::Base
  #attr_accessible :name, :household_id
  attr_reader :name
  attr_accessor :relationship, :name_related, :successors
  serialize :successors, Array
  belongs_to :household
  RELATIONSHIP_KINDS = %w(spouse mother father child unrelated grandchild aunt_uncle niece_nephew grandparent)

  #field :family_member_id, type: BSON::ObjectId

  after_initialize do |household_member| #(name)
    @name ||= household_member[:name]
    @successors ||= []
  end

  def add_relationship(successor, relationship_kind)
    @successors << successor
    #Add relationships only:
        # - If the same relation (predecessor, sucessor) does not exist.
          # -  Populate the Inverse relation too.
    if relation_is_blank?(successor)
      # Populate Direct Relationship
      Relationship.create(household_id: self.household.id, predecessor_id: self.id, successor_id: successor.id, relationship: relationship_kind)
      # Poupulate Inverse Relationship

      Relationship.create(household_id: self.household.id, predecessor_id: successor.id, successor_id: self.id, relationship: Household::RELATIONSHIP_INVERSE_KINDS[relationship_kind.to_sym].to_s)
    end
  end

  def to_s
    "#{@name} -> [#{@successors.map(&:name).join(' ')}]"
  end

  def relation_is_blank?(successor)
    Relationship.where(household_id:self.household.id, predecessor_id: self.id, successor_id: successor.id).blank?
  end
end
