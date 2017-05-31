require 'rails_helper'

describe Homebrew::FormulaDependency, type: :model do
  describe 'DB' do
    it do
      should have_db_column(:formula_id).of_type(:integer)
        .with_options(null: false)
    end
    it do
      should have_db_column(:dependency_id).of_type(:integer)
        .with_options(null: false)
    end
    it { should have_db_index([:formula_id, :dependency_id]).unique(true) }
  end

  describe 'Links' do
    it { should belong_to(:formula) }
    it { should belong_to(:dependency).class_name('Homebrew::Formula') }
  end

  describe 'Validations' do
    it { should validate_presence_of(:formula_id) }
    it { should validate_presence_of(:dependency_id) }
    it do
      formula = Homebrew::Formula.create!(
        filename: FFaker::Lorem.words.join(' '),
        name: FFaker::Lorem.word
      )
      Homebrew::FormulaDependency.create!(formula: formula, dependency: formula)
      should validate_uniqueness_of(:dependency_id).scoped_to(:formula_id)
    end
  end
end
