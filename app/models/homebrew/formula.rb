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
    has_and_belongs_to_many :dependencies,
      -> { uniq },
      association_foreign_key: :dependency_id,
      class_name: "Homebrew::Formula",
      join_table: :dependencies_formulas

    # @nodoc ~~~ validations ~~~
    validates :filename, presence: true, uniqueness: true
    validates :name, presence: true

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

    def has_description?
      self[:description].present?
    end

  end
end
