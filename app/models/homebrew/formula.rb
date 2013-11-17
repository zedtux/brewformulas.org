# A Homebrew formula
#
# Represents a formula used by Homebrew.
#
# @author [guillaumeh]
module Homebrew
  class Formula < ActiveRecord::Base

    # @nodoc ~~~ special behaviours ~~~
    self.table_name = "homebrew_formulas"

    # @nodoc ~~~ validations ~~~
    validates :name, presence: true, uniqueness: true

    # @nodoc ~~~ custom class methods ~~~

    # @nodoc ~~~ custom instance methods ~~~

  end
end
