require "spec_helper"

describe ApplicationHelper do
  describe "#bootstrap_class_for" do
    context "passing a nil" do
      it "should return a blank string" do
        helper.bootstrap_class_for(nil).should be_blank
      end
    end
    context "passing the Symbol :success" do
      it "should return the string 'alert-success'" do
        helper.bootstrap_class_for(:success).should == "alert-success"
      end
    end
    context "passing the Symbol :error" do
      it "should return the string 'alert-danger'" do
        helper.bootstrap_class_for(:error).should == "alert-danger"
      end
    end
    context "passing the Symbol :warning" do
      it "should return the string 'alert-warning'" do
        helper.bootstrap_class_for(:warning).should == "alert-warning"
      end
    end
    context "passing the Symbol :notice" do
      it "should return the string 'alert-info'" do
        helper.bootstrap_class_for(:notice).should == "alert-info"
      end
    end
    context "passing the Symbol :not_managed_symbol" do
      it "should return the string 'not_managed_symbol'" do
        helper.bootstrap_class_for(:not_managed_symbol).should == "not_managed_symbol"
      end
    end
    context "passing a string this_is_not_a_symbol" do
      it "should return the string 'this_is_not_a_symbol'" do
        helper.bootstrap_class_for("this_is_not_a_symbol").should == "this_is_not_a_symbol"
      end
    end
  end

  describe "#import_status_class" do
    context "passing a running Import" do
      it "should return an empty string" do
        helper.import_status_class(Import.new).should == ""
      end
    end
    context "passing a finished Import" do
      context "which has failed" do
        it "should return the String \"danger\"" do
          helper.import_status_class(Import.new(ended_at: Time.now, success: false)).should == "danger"
        end
      end
      context "which has succeed" do
        it "should return the String \"success\"" do
          helper.import_status_class(Import.new(ended_at: Time.now, success: true)).should == "success"
        end
      end
    end
  end
end
