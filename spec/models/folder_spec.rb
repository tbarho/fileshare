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

  describe "user associations" do
    before(:each) do
      @folder = @user.folders.create!(@attr)
    end

    describe "owner" do
      before(:each) do
        @owner = @user
      end

      it "should have an owner attribute" do
        @folder.should respond_to(:owner)
      end
      it "should have the right associated owner" do
        @folder.owner_id.should == @owner.id
        @folder.owner.should == @owner
      end
    end

  end

  describe "folder associations" do
    before(:each) do
      @parent = @user.folders.create!(:name => "Parent Folder")
      @folder = @user.folders.create!(:name => "Subject Folder", :parent => @parent)
      @child_1 = @user.folders.create!(:name => "Child Folder 1", :parent => @folder)
      @child_2 = @user.folders.create!(:name => "Child Folder 2", :parent => @folder)
    end
    
    describe "parent" do
      it "should have a parent attribute" do
        @folder.should respond_to(:parent)
      end
      it "should have the right parent" do
        @folder.parent_id.should == @parent.id
        @folder.parent.should == @parent
      end
      it "should not have a parent if its a root folder" do
        @parent.parent.should be_nil
      end
    end

    describe "folders (children)" do
      it "should have a folders attribute" do
        @folder.should respond_to(:folders)
      end
      it "should have the right child folders" do
        @folder.folders.should == [@child_1, @child_2]
      end
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
