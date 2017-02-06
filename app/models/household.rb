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

  def primary_member
    household_members.where(is_primary: true).first
  end

  def build_relationship_matrix
                       #yi
                    # Mike(13)   Carol(14)   Greg(15)
                    #  13           14          15
    #xi # Mike (13)   self       unrelated    parent   
        # Carol(14)   unrelated    self       
        # Greg (15)   child                    self

    #household_members = household_members.map(&:name)
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
    
    return matrix

    # matrix.each_with_index do |x, xi|
    #   x.each_with_index do |y, yi|
    #     puts "element [#{xi}, #{yi}] is #{y}"
    #   end
    # end

    # # visual representation 
    # puts household_members.map(&:name).join("            ")
    # puts household_members.map(&:id).join("               ")
    # matrix.each do |r|
    #   puts r.each { |p| p }.join("         ")
    # end

  end

  def find_existing_relationship(member_a_id, member_b_id)
    return "self" if member_a_id == member_b_id
    rel = Relationship.where(predecessor_id: member_a_id, successor_id: member_b_id).first
    return rel.relationship if rel.present?
  end
end
