require 'spec_helper'

describe Folder do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :name => "Test Folder"
    }
  end

  it "should create a new instance given valid attributes" do
      @user.folders.create!(@attr)
  end

  describe "associations" do
    before(:each) do
      @folder = @user.folders.create!(@attr)
    end

    describe "owner" do
      it "should have an owner attribute" do
        @folder.should respond_to(:user)
      end
      it "should have the right associated owner" do
        @folder.owner_id.should == @user.id
        @folder.owner.should == @owner
      end
    end

    describe "viewers" do
    end

    describe "editors" do
    end

    describe "invitations" do
    end

  end

  describe "validations" do
    it "should require an owner id" do
      Folder.new(@attr).should_not be_valid
    end

    it "should require nonblank name" do
      @user.folders.build(:name => "    ").should_not be_valid
    end

    it "should reject a long name" do
      @user.folders.build(:name => "a" * 51).should_not be_valid
    end
  end

end
