require 'spec_helper'

describe ApplicationHelper, type: :helper do
  describe '#bootstrap_class_for' do
    context 'passing a nil' do
      it 'should return a blank string' do
        expect(helper.bootstrap_class_for(nil)).to be_blank
      end
    end
    context 'passing the Symbol :success' do
      it "should return the string 'alert-success'" do
        expect(helper.bootstrap_class_for(:success)).to eql('alert-success')
      end
    end
    context 'passing the Symbol :error' do
      it "should return the string 'alert-danger'" do
        expect(helper.bootstrap_class_for(:error)).to eql('alert-danger')
      end
    end
    context 'passing the Symbol :warning' do
      it "should return the string 'alert-warning'" do
        expect(helper.bootstrap_class_for(:warning)).to eql('alert-warning')
      end
    end
    context 'passing the Symbol :notice' do
      it "should return the string 'alert-info'" do
        expect(helper.bootstrap_class_for(:notice)).to eql('alert-info')
      end
    end
    context 'passing the Symbol :not_managed_symbol' do
      it "should return the string 'not_managed_symbol'" do
        expect(helper.bootstrap_class_for(:not_managed_symbol))
          .to eql('not_managed_symbol')
      end
    end
    context 'passing a string this_is_not_a_symbol' do
      it "should return the string 'this_is_not_a_symbol'" do
        expect(helper.bootstrap_class_for('this_is_not_a_symbol'))
          .to eql('this_is_not_a_symbol')
      end
    end
  end

  describe '#import_status_class' do
    context 'passing a running Import' do
      it 'should return an empty string' do
        expect(helper.import_status_class(Import.new)).to be_blank
      end
    end
    context 'passing a finished Import' do
      context 'which has failed' do
        it 'should return the String "danger"' do
          import = Import.new(ended_at: Time.now, success: false)
          expect(helper.import_status_class(import)).to eql('danger')
        end
      end
      context 'which has succeed' do
        it 'should return the String "success"' do
          import = Import.new(ended_at: Time.now, success: true)
          expect(helper.import_status_class(import)).to eql('success')
        end
      end
    end
  end
end
