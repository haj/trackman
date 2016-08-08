class CompaniesController < ApplicationController
  # Initialize something from GEM
  load_and_authorize_resource

  # Callback controller
  before_action :set_company, only: [:edit, :show, :update, :destroy]


  # GET /companies || companies_path
  # Show all companies
  def index
    @companies = Company.all

    respond_with(@companies)
  end

  def show
    if current_user.has_role?(:manager)
      ActsAsTenant.with_tenant(@company) do
        @employees = @company.users.all
      end 
    else
      @employees = Array.new
    end

    respond_with(@company)
  end

  # GET /companies/new
  def new
    @company = Company.new

    respond_with(@company)
  end

  # GET /companies/1/edit
  def edit
    respond_with(@company)
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    if @company.save
      respond_with(@company, location: @company, notice: 'Company was successfully created.')
    else
      respond_with(@company)
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    if @company.update(company_params)
      respond_with(@company, location: @company, notice: 'Company was successfully updated.')
    else
      respond_with(@company)
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy

    respond_with(@company, location: companies_url, notice: 'Company was successfully destroyed.')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Company.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    params.require(:company).permit(:name, :subdomain, :time_zone)
  end
end
