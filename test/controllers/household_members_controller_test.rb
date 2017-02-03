require 'test_helper'

class HouseholdMembersControllerTest < ActionController::TestCase
  setup do
    @household_member = household_members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:household_members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create household_member" do
    assert_difference('HouseholdMember.count') do
      post :create, household_member: {  }
    end

    assert_redirected_to household_member_path(assigns(:household_member))
  end

  test "should show household_member" do
    get :show, id: @household_member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @household_member
    assert_response :success
  end

  test "should update household_member" do
    patch :update, id: @household_member, household_member: {  }
    assert_redirected_to household_member_path(assigns(:household_member))
  end

  test "should destroy household_member" do
    assert_difference('HouseholdMember.count', -1) do
      delete :destroy, id: @household_member
    end

    assert_redirected_to household_members_path
  end
end
