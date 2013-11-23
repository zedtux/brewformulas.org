class FormulasController < ApplicationController

  def index
    @formula_count = Homebrew::Formula.where("touched_on = ?", Date.today).count

    @formulas = Homebrew::Formula.where("touched_on = ?", Date.today)
    @formulas = @formulas.order(:name)

    # Search box
    if params[:search] && params[:search][:name_or_keyword].present?
      @formulas = @formulas.where("name iLIKE ?", "%#{params[:search][:name_or_keyword]}%")
    end
  end

end
