class HouseholdMember < ActiveRecord::Base
  #attr_accessible :name, :household_id
  attr_reader :name
  attr_accessor :relationship, :name_related, :successors
  #serialize :successors, Array
  belongs_to :household
  has_many :relationships, dependent: :destroy
  RELATIONSHIP_KINDS = %w(spouse mother father child unrelated grandchild aunt_uncle niece_nephew grandparent)

  #field :family_member_id, type: BSON::ObjectId

  after_initialize do |household_member| #(name)
    @name ||= household_member[:name]
    @successors ||= []
  end

  def to_s
    "#{@name} -> [#{@successors.map(&:name).join(' ')}]"
  end

  def add_relationship(successor, relationship_kind)
    @successors << successor
    if same_successor_exists?(successor)
      direct_relationship = relationships.where(predecessor_id: self.id, successor_id: successor.id).first
      inverse_relationship = relationships.where(predecessor_id: successor.id, successor_id: self.id).first
      direct_relationship.update(relationship: relationship_kind)
      inverse_relationship.update(relationship: inverse_relationship_kind(relationship_kind))
    else
      if self.id != successor.id
        relationships.create(household_id: self.household.id, predecessor_id: self.id, successor_id: successor.id, relationship: relationship_kind) # Direct Relationship
        relationships.create(household_id: self.household.id, predecessor_id: successor.id, successor_id: self.id, relationship: inverse_relationship_kind(relationship_kind)) # Inverse Relationship
      end
    end
  end

  def same_successor_exists?(successor)
    relationships.where(predecessor_id: self.id, successor_id: successor.id).first.present?
  end

  def inverse_relationship_kind(relationship_kind)
    Household::RELATIONSHIP_INVERSE_KINDS[relationship_kind.to_sym].to_s
  end
end
