class HouseholdsController < ApplicationController
  before_action :set_household, only: [:show, :edit, :update, :destroy]

  # GET /households
  # GET /households.json
  def index
    @households = Household.all
  end

  # GET /households/1
  # GET /households/1.json
  def show
  end

  # GET /households/new
  def new
    @household = Household.new
    1.times { @household.household_members << HouseholdMember.new }
    @members = @household.household_members
    @relationships = []
  end

  # GET /households/1/edit
  def edit
    @members = Household.find(params[:id]).household_members
    @relationships = Relationship.where(household_id: params[:id])
  end

  # POST /households
  # POST /households.json
  def create
    @household = Household.new(household_params)

    respond_to do |format|
      if @household.save
        format.html { redirect_to @household, notice: 'Household was successfully created.' }
        format.json { render :show, status: :created, location: @household }
      else
        format.html { render :new }
        format.json { render json: @household.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /households/1
  # PATCH/PUT /households/1.json
  def update
    respond_to do |format|
      if @household.update(household_params)

        params[:household][:household_members_attributes].each do |member|
          predecessor_name = member[1][:name]
          successor_name = member[1][:name_related]
          relationship_kind = member[1][:relationship]

          @household.add_household_member(@household.household_members.find_by_name(predecessor_name))
          @household.add_relationship(predecessor_name, successor_name, relationship_kind)
          #byebug
        end
        format.html { redirect_to @household, notice: 'Household was successfully updated.' }
        format.json { render :show, status: :ok, location: @household }
      else
        format.html { render :edit }
        format.json { render json: @household.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /households/1
  # DELETE /households/1.json
  def destroy
    @household.destroy
    respond_to do |format|
      format.html { redirect_to households_url, notice: 'Household was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_household
      @household = Household.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def household_params
      #params.fetch(:household, {})
      #params.require(:household).permit(:name, household_member_attributes: :name)
      params.require(:household).permit(:name, household_members_attributes: [:id, :name, :relationship, :name_related, :primary_applicant, :household_id, :created_at, :updated_at])

    end
end
