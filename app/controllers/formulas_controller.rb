class FormulasController < ApplicationController
  before_filter :current_object, only: [:show, :refresh_description]

  def index
    @formula_count = Homebrew::Formula.where("touched_on = ?", Date.today).count

    @formulas = Homebrew::Formula.where("touched_on = ?", Date.today)
    @formulas = @formulas.order(:name)

    # Search box
    if params[:search] && params[:search][:term].present?
      @formulas = @formulas.where("filename iLIKE ? OR name iLIKE ?", "%#{params[:search][:term]}%", "%#{params[:search][:term]}%")
    end
  end

  def show; end

  def refresh_description
    FormulaDescriptionFetchWorker.perform_async(@formula.id)
    flash[:success] = "Your request has been successfully submitted."
    redirect_to action: "show", id: @formula.name
  end

private

  def current_object
    @formula = Homebrew::Formula.find_by!(name: params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "This formula doesn't exists"
    redirect_to root_url
  end

end
