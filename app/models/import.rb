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

  # @nodoc ~~~ custom instance methods ~~~

end
