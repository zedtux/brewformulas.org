class DependenciesController < ApplicationController
  include Pres::Presents

  before_action :current_object, only: :index

  def index
    @presented_formula = present(@formula)

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def current_object
    @formula = Homebrew::Formula.find_by!(name: params[:formula_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html do
        flash[:error] = 'This formula doesn\'t exists'
        redirect_to root_url
      end
      format.json { render json: {}, status: :not_found }
    end
  end
end
