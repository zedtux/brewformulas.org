#
# Formulas controller
#
# @author [guillaumeh]
#
class FormulasController < ApplicationController
  before_filter :current_objects, only: :index
  before_filter :calculate_percentage, only: :index
  before_filter :current_object, only: [:show, :refresh_description]

  def index
    @new_since_a_week = Homebrew::Formula.internals.new_this_week.order(:name)
    @inactive_formulas = Homebrew::Formula.internals.inactive.order(:name)
    if @inactive_formulas.present?
      @first_import_end_date = Import.first.ended_at.to_date
    end
  end

  def show; end

  def refresh_description
    FormulaDescriptionFetchWorker.perform_async(@formula.id)
    flash[:success] = 'Your request has been successfully submitted.'
    redirect_to action: 'show', id: @formula.name
  end

  def search
    @formulas = Homebrew::Formula.active_or_external.where(
                  'filename iLIKE ? OR name iLIKE ?',
                  "%#{params[:search][:term]}%",
                  "%#{params[:search][:term]}%"
                ).order(:name)
  end

  private

  def current_object
    @formula = Homebrew::Formula.find_by!(name: params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "This formula doesn't exists"
    redirect_to root_url
  end

  def current_objects
    @formulas = Homebrew::Formula.internals.active.order(:name)
  end

  def calculate_percentage
    with_a_description_count = Homebrew::Formula.internals
                                                .with_a_description.count
    @coverage = 0
    unless with_a_description_count.zero?
      @coverage = (with_a_description_count * 100) / @formulas.size
    end
  end
end
