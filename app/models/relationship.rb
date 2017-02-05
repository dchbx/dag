class Relationship < ActiveRecord::Base
  belongs_to :household_members
  
  def find_relationship()
  end
end
