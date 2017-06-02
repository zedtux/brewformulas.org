module Homebrew
  # Conflict link between formulas
  #
  # @author [guillaumeh]
  #
  class FormulaConflict < ApplicationRecord
    # @nodoc ~~~ special behaviours ~~~

    # @nodoc ~~~ callbacks ~~~

    # @nodoc ~~~ links ~~~
    belongs_to :formula
    belongs_to :conflict, class_name: 'Homebrew::Formula'

    # @nodoc ~~~ validations ~~~
    validates :formula_id, presence: true
    validates :conflict_id, presence: true, uniqueness: { scope: :formula_id }

    # @nodoc ~~~ custom class methods ~~~

    # @nodoc ~~~ custom instance methods ~~~
  end
end
