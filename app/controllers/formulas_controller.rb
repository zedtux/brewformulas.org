class FormulasController < ApplicationController
  before_action :current_object, only: [:show, :refresh]
  before_action :new_formulae_since_a_week, only: :index

  def index
    respond_to do |format|
      format.html do
        @trending_formulae = Homebrew::Formula.most_hit(1.month.ago, 8)
        @inactive_formulas = Homebrew::Formula.internals
                                              .inactive
                                              .order(:name)
                                              .limit(8)
      end
      format.json do
        render json: Homebrew::Formula.internals.active.order(:name)
      end
    end
  end

  def show
    @formula.punch(request) unless @formula.inactive?

    respond_to do |format|
      format.html
      format.json { render json: @formula, status: :ok }
    end
  end

  def refresh
    FormulaDescriptionFetchWorker.perform_async(@formula.id)
    flash[:success] = t('messages.request_successfully_submitted')

    respond_to do |format|
      format.html do
        @formula.reload

        render action: :show
      end
      format.js
    end
  end

  def search_term
    @search_term ||= params.require(:search).permit(:terms, :names, :filenames,
                                                    :descriptions, :term)
  rescue ActionController::ParameterMissing
    nil
  end

  def search
    @search_context = SearchFormulas.call(search_term)
    updates_params_from_search_context! if @search_context.success?

    render action: :index
  end

  private

  def current_object
    @formula = Homebrew::Formula.find_by!('LOWER(name) = ?',
                                          params[:id].downcase)
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html do
        flash[:error] = 'This formula doesn\'t exists'
        redirect_to root_url
      end
      format.json { render json: {}, status: :not_found }
    end
  end

  def new_formulae_since_a_week
    @new_formulae_since_a_week = Homebrew::Formula.internals
                                                  .new_this_week
                                                  .order(:name)
                                                  .limit(8)
  end

  def updates_params_from_search_context!
    params[:search][:terms] = @search_context.terms
    @search_term[:terms] = @search_context.terms
    params[:search][:names] = @search_context.names
    params[:search][:filenames] = @search_context.filenames
    params[:search][:descriptions] = @search_context.descriptions
  end
end
