class FormulasController < ApplicationController

  def index
    @formulas = Homebrew::Formula.where("touched_on = ?", Date.today).order(:name).load
  end

end
