require 'test_helper'

class HouseholdTest < ActiveSupport::TestCase
  
  test "valid household" do   
    assert Household.new.valid? true
  end

end
