module HouseholdsHelper
  def print_relationship(rel)
    predecessor = HouseholdMember.find(rel.predecessor_id).name
    successor = HouseholdMember.find(rel.successor_id).name
    relationship = rel.relationship
    preposition = relationship == 'unrelated' ? 'to' : 'of'
    "<b>#{predecessor}</b> is <b>#{relationship}</b> #{preposition} <b>#{successor}</b>".html_safe
  end

  def find_relationship(household_member)
    rel = household_member.relationships.where(predecessor_id: household_member.id).first
    rel.present? ? rel.relationship : ""
  end

  def find_relation_to(household_member)
    rel = household_member.relationships.where(predecessor_id: household_member.id).first
    rel.present? ? HouseholdMember.find(rel.successor_id).name : "" 
  end
end
