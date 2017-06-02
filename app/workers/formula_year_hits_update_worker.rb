#
# Background job to update the year_hits column for all formulas
#
# @author [guillaumeh]
#
class FormulaYearHitsUpdateWorker
  include Sidekiq::Worker

  def perform
    Homebrew::Formula.active.find_each do |formula|
      serialize_year_hits_for_11_previous_months_for(formula)
    end
  end

  private

  #
  # Populate a database field wiht the 11 previous months of hits in order to
  # cache it, the current month will be calculated on the fly.
  #
  # This should be ran at the first day of each months.
  #
  def serialize_year_hits_for_11_previous_months_for(formula)
    year_and_months = []

    11.times.with_index do |index|
      year_and_months << I18n.l(Date.today - index.month, format: '%Y%m')
    end

    build_yearly_hits = formula.send(:month_hits_for, year_and_months).reverse

    formula.update(yearly_hits: build_yearly_hits)
  end
end
