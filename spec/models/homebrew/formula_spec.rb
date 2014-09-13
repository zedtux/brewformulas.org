require 'spec_helper'

describe Homebrew::Formula do

  describe 'DB' do
    it do
      should have_db_column(:name).of_type(:string)
                                  .with_options(null: false)
    end
    it { should have_db_column(:version).of_type(:string) }
    it { should have_db_column(:homepage).of_type(:string) }
    it { should have_db_column(:description).of_type(:text) }
    it { should have_db_column(:touched_on).of_type(:date) }
    it do
      should have_db_column(:filename).of_type(:string)
                                      .with_options(null: false)
    end
    it do
      should have_db_column(:description_automatic).of_type(:boolean)
                                                   .with_options(default:
                                                                 false)
    end
    it do
      should have_db_column(:external).of_type(:boolean)
                                      .with_options(default: false,
                                                    null: false)
    end
    it { should have_db_index(:filename) }
    it { should have_db_index(:external) }
  end

  describe 'Links' do
    it { should have_many(:formula_dependencies).dependent(:destroy) }
    it { should have_many(:dependencies).through(:formula_dependencies) }
    it do
      should have_many(:formula_dependents)
        .class_name('Homebrew::FormulaDependency')
        .with_foreign_key(:dependency_id)
    end
    it do
      should have_many(:dependents).through(:formula_dependents)
        .source(:formula)
    end
    it do
      should have_many(:formula_conflicts).dependent(:destroy)
    end
    it do
      should have_many(:conflicts).through(:formula_conflicts)
    end
    it do
      should have_many(:revert_formula_conflicts)
        .class_name('Homebrew::FormulaConflict')
        .with_foreign_key(:conflict_id)
    end
    it do
      should have_many(:revert_conflicts)
        .through(:revert_formula_conflicts)
        .source(:formula)
    end
  end

  describe 'Validations' do
    it { should validate_presence_of(:filename) }
    it 'should validate uniqueness of the filename' do
      Homebrew::Formula.create!(filename: 'test', name: 'Test')
      should validate_uniqueness_of(:filename)
    end
    it { should validate_presence_of(:name) }
  end

end
