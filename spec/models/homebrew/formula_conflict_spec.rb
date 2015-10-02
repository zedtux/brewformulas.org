require 'spec_helper'

describe Homebrew::FormulaConflict do
  describe 'DB' do
    it do
      should have_db_column(:formula_id).of_type(:integer)
        .with_options(null: false)
    end
    it do
      should have_db_column(:conflict_id).of_type(:integer)
        .with_options(null: false)
    end
    it { should have_db_index([:formula_id, :conflict_id]).unique(true) }
  end

  describe 'Links' do
    it { should belong_to(:formula) }
    it { should belong_to(:conflict).class_name('Homebrew::Formula') }
  end

  describe 'Validations' do
    it { should validate_presence_of(:formula_id) }
    it { should validate_presence_of(:conflict_id) }
    it do
      Homebrew::FormulaConflict.create!(formula_id: 1, conflict_id: 1)
      should validate_uniqueness_of(:conflict_id).scoped_to(:formula_id)
    end
  end
end
