class Household < ActiveRecord::Base
  #attr_accessible :name, :household_members_attributes
  has_many :household_members
  accepts_nested_attributes_for :household_members, allow_destroy: true

  RELATIONSHIP_INVERSE_KINDS = { parent: :child,
                                spouse: :spouse,
                                child: :parent,
                                unrelated: :unrelated,
                                grandchild: :grandparent,
                                aunt_uncle: :niece_nephew,
                                niece_nephew: :aunt_uncle,
                                grandparent: :grandchild,
                                sibling: :sibling }

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

  def primary_member
    household_members.where(is_primary: true).first
  end

  def build_relationship_matrix
    household_members_id = household_members.map(&:id)
    matrix_size = household_members.count
    matrix = Array.new(matrix_size){Array.new(matrix_size)} #[n*n] square matrix.
    id_map = {}
    household_members_id.each_with_index { |hmid, index| id_map.merge!(index => hmid ) }
    matrix.each_with_index do |x, xi|
      x.each_with_index do |y, yi|
        matrix[xi][yi] = find_existing_relationship(id_map[xi], id_map[yi])
        matrix[yi][xi] = find_existing_relationship(id_map[yi], id_map[xi]) # Populate Inverse
      end
    end
    matrix = apply_rules_and_update_relationships(matrix)
    return matrix
  end

  def find_existing_relationship(member_a_id, member_b_id)
    return "self" if member_a_id == member_b_id
    rel = Relationship.where(predecessor_id: member_a_id, successor_id: member_b_id).first
    return rel.relationship if rel.present?
  end

  def find_missing_relationships(matrix)
    id_map = {}
    household_members_id = household_members.map(&:id)
    household_members_id.each_with_index { |hmid, index| id_map.merge!(index => hmid ) }
    missing_relationships = []
    matrix.each_with_index do |x, xi|
      x.each_with_index do |y, yi|
        if (xi > yi) && matrix[xi][yi].blank?
          missing_relationships << {id_map[xi] => id_map[yi]}
        end
      end
    end
    missing_relationships
  end

  def apply_rules_and_update_relationships(matrix)
    missing_relationship = find_missing_relationships(matrix)

    #Sibling rule
    missing_relationship.each do |rel|
      relation = Relationship.where(household_id: self.id, predecessor_id: rel.to_a.flatten, relationship: "child")
      s_ids = relation.collect(&:successor_id)

      if s_ids.count > s_ids.uniq.count
        members = household_members.where(id: rel.to_a.flatten)
        members.first.add_relationship(members.last, "sibling")
      end
    end

    #GrandParent-GrandChild Rule
    missing_relationship.each do |rel|
      relation = Relationship.where(household_id: self.id, successor_id: rel.to_a.flatten, relationship: ['parent', 'child'])
      r_types = relation.collect(&:relationship)
      s_ids = relation.collect(&:predecessor_id)

      if r_types.uniq.count >= 2 && s_ids.count != s_ids.uniq.count
        grandchild = household_members.where(id: relation.where(relationship: 'parent').first.successor_id).first
        grandparent = household_members.where(id: relation.where(relationship: 'child').first.successor_id).first
        grandparent.add_relationship(grandchild, "grandparent")
      end
    end

    # Rule No 1: If A->B is Parent Relationship and B->C is also Parent Relationship then, A->C is Grandparent.
    # Rule No 2: If A->B is Child Relationship and B->C is also Child Relationship then, A->C is Grandchild.
    # Rule No.3: A and B are unrelated if A's & B's parent are not related.?
    return matrix
  end

end
