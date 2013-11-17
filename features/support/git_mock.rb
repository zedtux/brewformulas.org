module HomebrewFormula
  mattr_accessor :formulas

  def self.new_formula(formula={})
    self.formulas ||= []
    self.formulas << formula
  end

  def self.write_formulae_to(formula_basedir)
    self.formulas.each do |formula|
      formula_content = "require 'formula'\n\nclass #{formula[:name].camelize} < Formula\n"
      formula.keys.each do |attribute|
        next if attribute == :name
        formula_content << "  #{attribute} \"#{formula[attribute.to_sym]}\"\n"
      end
      formula_content << "\nend\n"
      File.open(File.join(formula_basedir, "#{formula[:name].downcase}.rb"), "w") {|f|
        f.write(formula_content)
      }
    end
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
