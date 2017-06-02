module Formulas
  class TrendingsController < ApplicationController
    before_action :trending_formulae, only: :index

    def index
    end

    private

    def trending_formulae
      @trending_formulae = Homebrew::Formula.most_hit(1.month.ago, nil)
    end
  end
end
