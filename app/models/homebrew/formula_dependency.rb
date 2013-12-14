module Homebrew
  # Dependency link between formulas
  #
  # @author [guillaumeh]
  #
  class FormulaDependency < ActiveRecord::Base
    # @nodoc ~~~ special behaviours ~~~
    self.table_name = 'homebrew_formula_dependencies'

    # @nodoc ~~~ callbacks ~~~

    # @nodoc ~~~ links ~~~
    belongs_to :formula
    belongs_to :dependency, class_name: 'Homebrew::Formula'

    # @nodoc ~~~ validations ~~~
    validates :formula_id, presence: true
    validates :dependency_id,
              presence: true,
              uniqueness: { scope: :formula_id }

    # @nodoc ~~~ custom class methods ~~~

    # @nodoc ~~~ custom instance methods ~~~
  end
end
