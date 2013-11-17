require "spec_helper"

describe Homebrew::Formula do

  describe "DB" do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:version).of_type(:string) }
    it { should have_db_column(:homepage).of_type(:string) }
    it { should have_db_column(:description).of_type(:text) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

end
