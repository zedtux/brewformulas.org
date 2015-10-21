#
# Formulas controller
#
# @author [guillaumeh]
#
class FormulasController < ApplicationController
  before_action :current_objects, only: :index
  before_action :calculate_percentage, only: :index
  before_action :new_since_a_week, only: :index
  before_action :inactive_formulas, only: :index
  before_action :first_import_end_date, only: :index
  before_action :current_object, only: [:show, :refresh_description]
  before_action :respond_with_format, except: [:refresh_description, :search]

  # Allowed formats for this controller
  respond_to :html, :json

  def index; end

  def show; end

  def refresh_description
    FormulaDescriptionFetchWorker.perform_async(@formula.id)
    flash[:success] = 'Your request has been successfully submitted.'
    redirect_to action: 'show', id: @formula.name
  end

  def search
    search_term = params[:search][:term]
    @formulas = Homebrew::Formula.active_or_external.where(
      'filename ILIKE ? OR name ILIKE ? OR description ILIKE ?',
      "%#{search_term}%",
      "%#{search_term}%",
      "%#{search_term}%",
    ).order(:name)
  end

  private

  def current_object
    @formula = Homebrew::Formula.where('lower(name) = ?',
                                       params[:id].downcase).first!
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html do
        flash[:error] = 'This formula doesn\'t exists'
        redirect_to root_url
      end
      format.json { respond_with({}, status: :not_found) }
    end
  end

  def current_objects
    @formulas = Homebrew::Formula.internals.active.order(:name)
  end

  def calculate_percentage
    with_a_description_count = Homebrew::Formula.internals
                               .with_a_description.count
    @coverage = 0
    @coverage = (with_a_description_count * 100) / @formulas.size unless
      with_a_description_count.zero? || @formulas.size.zero?
  end

  def new_since_a_week
    @new_since_a_week = Homebrew::Formula.internals.new_this_week.order(:name)
  end

  def inactive_formulas
    @inactive_formulas = Homebrew::Formula.internals.inactive.order(:name)
  end

  def first_import_end_date
    return unless @inactive_formulas.present?
    @first_import_end_date = Import.first.ended_at.to_date
  end

  def respond_with_format
    respond_to do |format|
      format.html
      format.json do
        if action_name == 'show'
          respond_with(@formula, status: :ok)
        else
          respond_with([], status: 415)
        end
      end
    end
  end
end
