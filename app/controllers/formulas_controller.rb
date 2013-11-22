class FormulasController < ApplicationController

  def index
    @formulas = Homebrew::Formula.order(:name).load
  end

end
