#
# Homebrew namespace
#
# This module embed any codes related to Homebrew for Mac
#
# @author [guillaumeh]
#
module Homebrew
  # A Homebrew formula
  #
  # @author [guillaumeh]
  #
  class Formula < ActiveRecord::Base
    # @nodoc ~~~ virtual attributes ~~~
    cattr_accessor :detected_service

    # @nodoc ~~~ special behaviours ~~~
    self.table_name = 'homebrew_formulas'

    # @nodoc ~~~ callbacks ~~~
    before_create :touch
    after_update :fetch_description

    # @nodoc ~~~ links ~~~
    # ~ Dependencies ~
    has_many :formula_dependencies, dependent: :destroy
    has_many :dependencies, through: :formula_dependencies
    has_many :formula_dependents,
             class_name: 'Homebrew::FormulaDependency',
             foreign_key: :dependency_id
    has_many :dependents, through: :formula_dependents, source: :formula
    # ~ Conflicts ~
    has_many :formula_conflicts, dependent: :destroy
    has_many :conflicts, through: :formula_conflicts
    has_many :revert_formula_conflicts,
             class_name: 'Homebrew::FormulaConflict',
             foreign_key: :conflict_id
    has_many :revert_conflicts,
             through: :revert_formula_conflicts,
             source: :formula

    # @nodoc ~~~ validations ~~~
    validates :filename, presence: true, uniqueness: true
    validates :name, presence: true

    # @nodoc ~~~ scopes ~~~
    scope :externals, -> { where(external: true) }
    scope :internals, -> { where(external: false) }
    scope :active, -> { where(touched_on: Import.last_succes_date_or_today) }
    scope :active_or_external, lambda {
      where('touched_on = ? OR external IS TRUE',
            Import.last_succes_date_or_today)
    }
    scope :new_this_week, lambda {
      where("created_at BETWEEN LOCALTIMESTAMP - INTERVAL '7 days' " \
            'AND LOCALTIMESTAMP')
    }
    scope :inactive, lambda {
      where('touched_on < ?', Import.last_succes_date_or_today)
    }
    scope :with_a_description, -> { where('description is not NULL') }

    # @nodoc ~~~ custom class methods ~~~

    # @nodoc ~~~ custom instance methods ~~~

    #
    # Get the description of the formula
    #
    # @return [String] description of the formula or "No description available"
    def description
      self[:description] || 'No description available'
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
    # @return [Boolean] true if the formula has a description in DB
    #   otherwise false
    def description?
      self[:description].present?
    end

    #
    # Names of the formulas which are dependent
    # on the current formula.
    #
    # @return [Array] with the names of the fromulas
    def dependent_names
      dependents.map(&:name)
    end

    def detect_service
      service_detection = ServiceDetection.new(homepage)
      service_detection.detected_service
    end

    def update_description_from!(html)
      # Update the detected_service
      self.detected_service = detect_service

      # Initialize a new Homebrew::Formula::Description
      # which will be responsible to extract the formula
      # description from the readed homepage content.
      description = Homebrew::Formula::Description.new(self)
      description.lookup_from(html)

      return unless description.found?
      return if update_attributes(
        description: description.text,
        description_automatic: true
      )

      Rails.logger.warn 'Unable to update description with text ' \
                        "#{description.text}"
    end

    def reference
      "Extracted automatically from #{name} homepage" if description_automatic?
    end

    #
    # Get if the formula is new
    #
    # @return [Boolean] return true if new otherwise false
    def new?
      created_at.to_date == Time.now.utc.to_date
    end

    def as_json(_options = {}) # rubocop:disable Metrics/AbcSize
      {
        formula: name.downcase,
        description: description.to_s,
        reference: reference.to_s,
        homepage: homepage.to_s,
        version: version.to_s,
        new: new?,
        dependencies: dependencies.map(&:name).sort,
        dependents: formula_dependents.map(&:formula).map(&:name).sort
      }
    end # rubocop:enable Metrics/AbcSize

    private

    def fetch_description
      # Don't update the description
      # until the homepage is updated
      return unless self.homepage_changed?

      FormulaDescriptionFetchWorker.perform_async(id)
    end
  end
end
