class FormulasController < ApplicationController
  before_filter :current_object, only: [:show, :refresh_description]

  def index
    current_date = Time.now.utc.to_date
    if import = Import.success.last
      current_date = import.ended_at.try(:to_date)
    end

    @formula_count = Homebrew::Formula.internals.where("touched_on = ?", current_date).count

    # Search box
    if params[:search] && params[:search][:term].present?
      @formulas = Homebrew::Formula.where("touched_on = ? OR external IS TRUE", current_date)
      @formulas = @formulas.where("filename iLIKE ? OR name iLIKE ?", "%#{params[:search][:term]}%", "%#{params[:search][:term]}%")
    else
      @formulas = Homebrew::Formula.where("touched_on = ?", current_date)
      # Don't show external dependencies in the big list
      @formulas = @formulas.internals
    end

    @formulas = @formulas.order(:name)
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
