require "spec_helper"

describe Homebrew::Formula do

  describe "DB" do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:version).of_type(:string) }
    it { should have_db_column(:homepage).of_type(:string) }
    it { should have_db_column(:description).of_type(:text) }
    it { should have_db_column(:touched_on).of_type(:date) }
    it { should have_db_column(:filename).of_type(:string).with_options(null: false) }
    it { should have_db_column(:description_automatic).of_type(:boolean).with_options(default: false) }
    it { should have_db_index(:filename) }
  end

  describe "Validations" do
    it { should have_and_belong_to_many(:dependencies).with_foreign_key(:dependency_id).class_name("Homebrew::Formula") }
  end

  describe "Validations" do
    it { should validate_presence_of(:filename) }
    it "should validate uniqueness of the filename" do
      Homebrew::Formula.create!(filename: "test", name: "Test")
      should validate_uniqueness_of(:filename)
    end
    it { should validate_presence_of(:name) }
  end

end
