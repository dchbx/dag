class HouseholdMembersController < ApplicationController
  before_action :set_household_member, only: [:show, :edit, :update, :destroy]

  # GET /household_members
  # GET /household_members.json
  def index
    @household_members = HouseholdMember.all
  end

  # GET /household_members/1
  # GET /household_members/1.json
  def show
  end

  # GET /household_members/new
  def new
    @household_member = HouseholdMember.new
  end

  # GET /household_members/1/edit
  def edit
  end

  # POST /household_members
  # POST /household_members.json
  def create
    @household_member = HouseholdMember.new(household_member_params)

    respond_to do |format|
      if @household_member.save
        format.html { redirect_to @household_member, notice: 'Household member was successfully created.' }
        format.json { render :show, status: :created, location: @household_member }
      else
        format.html { render :new }
        format.json { render json: @household_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /household_members/1
  # PATCH/PUT /household_members/1.json
  def update
    respond_to do |format|
      if @household_member.update(household_member_params)
        format.html { redirect_to @household_member, notice: 'Household member was successfully updated.' }
        format.json { render :show, status: :ok, location: @household_member }
      else
        format.html { render :edit }
        format.json { render json: @household_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /household_members/1
  # DELETE /household_members/1.json
  def destroy
    @household_member.destroy
    respond_to do |format|
      format.html { redirect_to household_members_url, notice: 'Household member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_household_member
      @household_member = HouseholdMember.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def household_member_params
      #params.fetch(:household_member, {})
      params.require(:household_member).permit(:id, :name, :primary_applicant, :household_id, :created_at, :updated_at)
    end
end
