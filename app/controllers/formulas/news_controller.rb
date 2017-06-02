module Formulas
  class NewsController < ApplicationController
    before_action :new_formulae_since_a_week, only: :index

    def index
    end

    private

    def new_formulae_since_a_week
      @new_formulae_since_a_week = Homebrew::Formula.internals
                                                    .new_this_week
                                                    .order(:name)
    end
  end
end
