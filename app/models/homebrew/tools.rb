module Homebrew
  #
  # Serie of tools to work with Homebrew formula files
  #
  # @author [guillaumeh]
  #
  module Tools
    # Extract the formula class name
    # In the case the formula declare more than one Formula class
    # use the latest one as the other are dependencies
    def self.extract_class_name(formula)
      inheriting_classes = %w(
        Formula
        ScriptFileFormula
        AmazonWebServicesFormula
        GithubGistFormula
      )
      class_name = formula.scan(
        /^class\s(\w+)\s<\s(?:#{inheriting_classes.join("|")})$/
      )
      class_name.flatten.last
    end

    def self.extract_attributes(formula)
      attributes_to_extract = %w(homepage version)
      # Extract the formula attributes shown on brewformulas.org
      extracted_attributes = formula.scan(
        /^\s+(#{attributes_to_extract.join("|")})\s+(?:'|")(.*)(?:'|")$/
      )
      Hash[*extracted_attributes.flatten]
    end

    def self.conflicts_because_check(conflicts)
      # Looks like it is a common type mistake:
      #  because => beacuse
      if conflicts.include?(':beacuse')
        Rails.logger.warn('Formula conflict "because" type mistake detected!')
        conflicts.gsub!(/:beacuse/, ':because')
      end
      conflicts
    end

    def self.extract_conflict_reason_if_possible!(conflicts)
      conflicts = conflicts_because_check(conflicts)

      if conflicts.include?(':because')
        conflicts, because = conflicts.split(':because')
        because.gsub!(/\s+=>\s+/, '')
      end
      [conflicts, because]
    end

    def self.get_conflicts(formula)
      conflicts = formula.scan(/^\s+conflicts_with\s+(.*)$/).flatten.first

      # No conflict found
      return [] unless conflicts

      conflicts.gsub!(/('|")/, '')

      conflicts, _ = extract_conflict_reason_if_possible!(conflicts)

      conflicting_formulas = conflicts.strip.split(',').map(&:strip)
      conflicting_formulas.map do |name|
        find_or_create_formula!(name, name.classify)
      end
    end

    def self.get_dependencies(formula)
      dependency_names = formula.scan(
        /^\s+depends_on\s(?:\'|\:)([\w\+\-]+).*$/
      )
      dependency_names.flatten!
      dependency_names.map do |name|
        find_or_create_formula!(name, name.classify)
      end
    end

    #
    # Find or create the Homebrew::Formula for a given filename and name
    #
    # In the case the method create the formula, it is created with
    # the external field to true so that, during the import, if a file
    # has been parsed for this formula, the external field will be
    # updated to false.
    #
    # @param  filename [String] Filename of the formula (without extention)
    # @param  name [String] Name to be displayed
    #
    # @return [Homebrew::Formula] The one found or created
    def self.find_or_create_formula!(filename, name)
      formula = Homebrew::Formula.find_by(filename: filename)
      return formula if formula

      Homebrew::Formula.create!(filename: filename, name: name, external: true)
    end
  end
end
