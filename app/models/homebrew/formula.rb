# A Homebrew formula
#
# Represents a formula used by Homebrew.
#
# @author [guillaumeh]
module Homebrew
  class Formula < ActiveRecord::Base

    # @nodoc ~~~ special behaviours ~~~
    self.table_name = "homebrew_formulas"

    # @nodoc ~~~ callbacks ~~~
    before_create :touch

    # @nodoc ~~~ links ~~~
    # ~ Dependencies ~
    has_many :formula_dependencies, dependent: :destroy
    has_many :dependencies, through: :formula_dependencies
    has_many :formula_dependents, class_name: "Homebrew::FormulaDependency", foreign_key: :dependency_id
    has_many :dependents, through: :formula_dependents, source: :formula
    # ~ Conflicts ~
    has_many :formula_conflicts, dependent: :destroy
    has_many :conflicts, through: :formula_conflicts
    has_many :revert_formula_conflicts, class_name: "Homebrew::FormulaConflict", foreign_key: :conflict_id
    has_many :revert_conflicts, through: :revert_formula_conflicts, source: :formula

    # @nodoc ~~~ validations ~~~
    validates :filename, presence: true, uniqueness: true
    validates :name, presence: true

    # @nodoc ~~~ scopes ~~~
    scope :externals, -> { where(external: true) }
    scope :internals, -> { where(external: false) }

    # @nodoc ~~~ custom class methods ~~~

    # @nodoc ~~~ custom instance methods ~~~

    #
    # Get the description of the formula
    #
    # @return [String] description of the formula or "No description available"
    def description
      self[:description] || "No description available"
    end

    #
    # Set the touched_on field
    #
    # The touched_on field is used in order to detect
    # deleted formula. When this field is older than
    # the day of today, it means the formula wasn't
    # touched when the background worker ran, so the
    # formula wasn't present from the Homebrew git repo.
    #
    def touch
      self.touched_on = Time.now.utc.to_date
    end

    #
    # Determine if the formula has a description
    #
    # @return [Boolean] true if the formula has a description in DB otherwise false
    def has_description?
      self[:description].present?
    end

    #
    # Names of the formulas which are dependent
    # on the current formula.
    #
    # @return [Array] with the names of the fromulas
    def dependent_names
      self.dependents.collect(&:name)
    end
  end
end
