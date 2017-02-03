module HouseholdsHelper
  def print_relationship(rel)
    predecessor = HouseholdMember.find(rel.predecessor_id).name
    successor = HouseholdMember.find(rel.successor_id).name
    relationship = rel.relationship
    "<b>#{predecessor}</b> is <b>#{relationship}</b> to <b>#{successor}</b>".html_safe
  end
end
