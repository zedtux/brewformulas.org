class FormulasController < ApplicationController

  def index
    @formula_count = Homebrew::Formula.where("touched_on = ?", Date.today).count

    @formulas = Homebrew::Formula.where("touched_on = ?", Date.today)
    @formulas = @formulas.order(:name)

    # Search box
    if params[:search] && params[:search][:term].present?
      @formulas = @formulas.where("filename iLIKE ? OR name iLIKE ?", "%#{params[:search][:term]}%", "%#{params[:search][:term]}%")
    end
  end

end
