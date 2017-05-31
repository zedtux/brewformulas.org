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
  class Formula < ApplicationRecord
    # @nodoc ~~~ virtual attributes ~~~
    cattr_accessor :detected_service

    # @nodoc ~~~ special behaviours ~~~
    acts_as_punchable
    serialize :yearly_hits, Array

    # @nodoc ~~~ callbacks ~~~
    before_create :touch
    before_validation :initialize_yearly_hits_if_needed
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

    def inactive?
      touched_on < Import.last_succes_date_or_today
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

    def tags
      []
    end

    #
    # Build the Homebrew's github URL to the current formula file
    #
    def url
      formula_url = Rails.configuration.homebrew.git_repository.url
      formula_url = formula_url.gsub(/\.git$/, '/tree/master/Formula/')
      formula_url << filename
      formula_url << '.rb'
    end

    #
    # Build an array of numbers representing the amount of hits per months per
    # months for a year time window. Used in order to build the formula visits
    # graph.
    #
    def year_hits
      year_and_month = I18n.l(Date.today - 0.month, format: '%Y%m')
      yearly_hits << month_hits_for(year_and_month).first
    end

    #
    # Returns the highest amount of hits in the last year.
    #
    def heighest_hit
      year_hits.max
    end

    private

    def fetch_description
      # Don't update the description
      # until the homepage is updated
      return unless self.saved_change_to_attribute?(:homepage)

      FormulaDescriptionFetchWorker.perform_async(id)
    end

    def month_hits_for(year_and_months)
      months_hits = Punch.unscoped
                         .group('year_and_month')
                         .where(punchable: self,
                                year_and_month: Array(year_and_months))
                         .count
      Array(year_and_months).each do |year_and_month|
        next if months_hits.key?(year_and_month)
        months_hits[year_and_month] = 0
      end

      months_hits.values.reverse
    end

    def initialize_yearly_hits_if_needed
      return if yearly_hits.is_a?(Array) && yearly_hits.present?

      if yearly_hits.is_a?(String)
        self.yearly_hits = JSON.parse(yearly_hits)
        return true
      end

      self.yearly_hits = [0,0,0,0,0,0,0,0,0,0,0]
    end
  end
end
