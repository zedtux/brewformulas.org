# Import of formulas
#
# @author [guillaumeh]
class Import < ActiveRecord::Base
  # @nodoc ~~~ special behaviours ~~~

  # @nodoc ~~~ callbacks ~~~

  # @nodoc ~~~ links ~~~

  # @nodoc ~~~ validations ~~~

  # @nodoc ~~~ scopes ~~~
  scope :success, -> { where(success: true) }

  # @nodoc ~~~ custom class methods ~~~

  #
  # Get the date to filter the formulas.
  #
  # @return [Date] Latest import date otherwise today's date
  def self.last_succes_date_or_today
    import = Import.success.last
    import ? import.ended_at.try(:to_date) : Time.now.utc.to_date
  end

  # @nodoc ~~~ custom instance methods ~~~
end
