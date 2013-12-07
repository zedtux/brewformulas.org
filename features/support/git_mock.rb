module HomebrewFormula
  mattr_accessor :formulas

  def self.new_formula(formula={})
    self.formulas ||= []
    formula.merge!(others: []) unless formula.has_key?(:others)
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

      formula_content = "require 'formula'\n\n"

      formula[:others].each do |sub_formula|
        formula_content << self.build_formula_class(sub_formula)
      end

      formula_content << self.build_formula_class(formula)

      File.open(File.join(formula_basedir, "#{formula[:name].downcase}.rb"), "w") {|f|
        f.write(formula_content)
      }
    end
  end

  def self.clean!
    self.formulas = []
    FileUtils.rm_rf(Git::Lib.root_path) if Git::Lib.root_path
  end

private

  def self.build_formula_class(formula)
    formula_content = ""

    # Class name and inheritance
    formula_content << "class #{formula[:name].camelize} < Formula\n"

    # Class attributes (homepage, version)
    formula.keys.each do |attribute|
      next if [:name, :others, :code, :depends_on, :conflicts_with].include?(attribute)
      formula_content << "  #{attribute} \"#{formula[attribute.to_sym]}\"\n"
    end

    # Dependencies
    if formula[:depends_on]
      [*formula[:depends_on]].each do |dependency|
        formula_content << "\n  depends_on '#{dependency.downcase}'\n"
      end
    end

    # Conflicts
    if formula[:conflicts_with]
      # Add conflict with double quotes and simple quotes
      conflicts = []
      [*formula[:conflicts_with][:formulas]].each_with_index do |formula_name, index|
        conflicts << (index.even? ? "\"#{formula_name}\"" : "'#{formula_name}'")
      end
      formula_content << "\n  conflicts_with #{conflicts.join(", ")}"
      if formula[:conflicts_with][:because]
        formula_content << ","
        formula_content << "\n  " if formula[:conflicts_with][:on_multiple_lines]
        formula_content << if formula[:conflicts_with][:because_issue]
          " :beacuse => '#{formula[:conflicts_with][:because]}'"
        else
          " :because => '#{formula[:conflicts_with][:because]}'"
        end
      end
      formula_content << "\n"
    end

    # Custom Ruby code
    if formula[:code]
      formula_content << "\n  #{formula[:code]}\n"
    end

    formula_content << "\nend\n"
    formula_content
  end
end
World(HomebrewFormula)

# This module mock the Git::Lib class from the ruby-git gem
module Git
  class Lib
    mattr_accessor :root_path, :working_dir

    def run_command(git_cmd, &block)
      if git_cmd.include?("\"--\"")
        action, url, self.root_path = git_cmd.scan(/git (\w+).* "--" "([\w\:\/\.\_\-]+)" "([\w\/\.\s]+)"/).first
      else
        action = git_cmd.scan(/git (\w+).*/).flatten.first
      end

      case action
      when "clone"
        FileUtils.mkdir_p(File.join(self.root_path, ".git"))
        self.working_dir = File.join(self.root_path, "Library", "Formula")
        FileUtils.mkdir_p(self.working_dir)
        HomebrewFormula.write_formulae_to(self.working_dir)
      when "pull"
        HomebrewFormula.write_formulae_to(self.working_dir)
      else
        raise "Not implemented Git action #{action}!"
      end

      true
    end
  end
end

After do
  HomebrewFormula.clean!
end
