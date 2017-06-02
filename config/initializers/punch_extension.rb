#
# Extends the punching_bag gem in order to populate the :year_and_month column
# with the current yeat and month.
# This data is used later for the grouping of the data.
#
module PunchPatch
  extend ActiveSupport::Concern

  included do
    before_validation :update_year_and_month
    before_create :update_year_and_month
  end

  private

  def update_year_and_month
    self.year_and_month = I18n.l(average_time, format: '%Y%m')
  end
end

Punch.send(:include, PunchPatch)
