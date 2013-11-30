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
    FileUtils.rm_rf Git::Lib.working_dir
  end

private

  def self.build_formula_class(formula)
    formula_content = ""
    formula_content << "class #{formula[:name].camelize} < Formula\n"
    formula.keys.each do |attribute|
      next if [:name, :others, :code].include?(attribute)
      formula_content << "  #{attribute} \"#{formula[attribute.to_sym]}\"\n"
    end
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
    mattr_accessor :working_dir

    def run_command(git_cmd, &block)
      if git_cmd.include?("\"--\"")
        action, url, location = git_cmd.scan(/git (\w+).* "--" "([\w\:\/\.\_\-]+)" "([\w\/\.\s]+)"/).first
      else
        action = git_cmd.scan(/git (\w+).*/).flatten.first
      end

      case action
      when "clone"
        FileUtils.mkdir_p(File.join(location, ".git"))
        self.working_dir = File.join(location, "Library", "Formula")
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
