#
# Mocking module for Formulas
#
# @author [guillaumeh]
#
module HomebrewFormula
  mattr_accessor :formulas

  def self.new_formula(formula = {})
    self.formulas ||= []
    formula.merge!(others: []) unless formula.key?(:others)
    self.formulas << formula
  end

  #
  # {
  #   formula_one: {name: "Test", homepage: "http://google.com/"}
  # }
  #
  # {
  #   formula_one: {name: "clang", homepage: "http://llvm.org"},
  #   formula_two: {name: "llvm", homepage: "http://llvm.org", primary: true}
  # }
  def self.write_formulae_to(formula_basedir)
    self.formulas.each do |formula|

      @formula_content = "require 'formula'\n\n"

      formula[:others].each do |sub_formula|
        @formula_content << build_formula_class(sub_formula)
      end

      @formula_content << build_formula_class(formula)
      write_formula(formula, formula_basedir)
    end
  end

  def self.write_formula(formula, basedir)
    formula_path = File.join(basedir, "#{formula[:name].downcase}.rb")
    File.open(formula_path, 'w') { |f| f.write(@formula_content) }
  end

  def self.clean!
    self.formulas = []
    FileUtils.rm_rf(Git::Lib.root_path) if Git::Lib.root_path
  end

  private

  def self.formula_attributes(formula)
    # Class attributes (homepage, version)
    formula.keys.each do |attribute|
      next if [:name, :others, :code, :depends_on, :conflicts_with
      ].include?(attribute)
      @formula_content << "  #{attribute} \"#{formula[attribute.to_sym]}\"\n"
    end
  end

  def self.formula_dependencies(formula)
    if formula[:depends_on]
      [*formula[:depends_on]].each do |dependency|
        @formula_content << "\n  depends_on '#{dependency.downcase}'\n"
      end
    end
  end

  def self.formula_conflict_with_because(formula)
    because_issue = formula[:conflicts_with][:because_issue]
    @formula_content << ','
    @formula_content << "\n  " if formula[:conflicts_with][:on_multiple_lines]
    @formula_content << ' '
    @formula_content << (because_issue ? ':beacuse' : ':because')
    @formula_content << " => '#{formula[:conflicts_with][:because]}'"
  end

  def self.formula_conflicts(formula)
    # Add conflict with double quotes and simple quotes
    conflicts = []
    formulas = [*formula[:conflicts_with][:formulas]]
    formulas.each_with_index do |formula_name, index|
      conflicts << index.even? ? "\"#{formula_name}\"" : "'#{formula_name}'"
    end
    @formula_content << "\n  conflicts_with #{conflicts.join(', ')}"

    if formula[:conflicts_with][:because]
      formula_conflict_with_because(formula)
    end

    @formula_content << "\n"
  end

  def self.formula_custom_ruby_code(formula)
    @formula_content << "\n  #{formula[:code]}\n" if formula[:code]
  end

  def self.build_formula_class(formula)
    @formula_content = ''

    # Class name and inheritance
    @formula_content << "class #{formula[:name].camelize} < Formula\n"

    formula_attributes(formula)
    formula_dependencies(formula)
    formula_conflicts(formula) if formula[:conflicts_with]
    formula_custom_ruby_code(formula)

    @formula_content << "\nend\n"
    @formula_content
  end
end
World(HomebrewFormula)

# This module mock the Git::Lib class from the ruby-git gem
module Git
  #
  # Git::Lib overriding for testing
  #
  # @author [guillaumeh]
  #
  class Lib
    mattr_accessor :root_path, :working_dir

    def make_paths
      FileUtils.mkdir_p(File.join(root_path, '.git'))
      self.working_dir = File.join(root_path, 'Library', 'Formula')
      FileUtils.mkdir_p(working_dir)
    end

    def run_action(action)
      case action
      when 'clone'
        make_paths
        HomebrewFormula.write_formulae_to(working_dir)
      when 'pull'
        HomebrewFormula.write_formulae_to(working_dir)
      else
        fail "Not implemented Git action #{action}!"
      end
    end

    def run_command(git_cmd, &block)
      if git_cmd.include?("\"--\"")
        regex = %r{git\s(\w+).*\s"--"\s"([\w\:\/\.\_\-]+)"\s"([\w\/\.\s]+)"}
        action, _, self.root_path = git_cmd.scan(regex).first
      else
        action = git_cmd.scan(/git (\w+).*/).flatten.first
      end

      run_action(action)
      true
    end
  end
end

After do
  HomebrewFormula.clean!
end
