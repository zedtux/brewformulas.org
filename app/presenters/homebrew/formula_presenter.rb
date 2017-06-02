module Homebrew
  class FormulaPresenter < Pres::Presenter
    delegate :dependents, to: :object
  end
end
