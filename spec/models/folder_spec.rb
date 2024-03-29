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

    describe "viewers" do
      before(:each) do
        @viewer = Factory(:user, :email => Factory.next(:email))
      end
      it "should have a viewers attribute" do
        @folder.should respond_to(:viewers)
      end
      it "should have an allowing_view_by? method" do
        @folder.should respond_to(:allowing_view_by?)
      end
      it "should allow a user to view" do
        @viewer.can_view!(@folder)
        @folder.should be_allowing_view_by(@viewer)
      end
      it "should DISallow a user from viewing" do
        @unauthorized_viewer = Factory(:user, :email => Factory.next(:email))
        @unauthorized_viewer.can_view!(@folder)
        @unauthorized_viewer.cannot_view!(@folder)
        @folder.should_not be_allowing_view_by(@unauthorized_viewer)
      end 
      it "should include the user in the viewers array" do
        @viewer.can_view!(@folder)
        @folder.viewers.should include(@viewer)
      end
    end

    describe "editors" do
      before(:each) do
        @editor = Factory(:user, :email => Factory.next(:email))
      end
      it "should have an editors attribute" do
        @folder.should respond_to(:editors)
      end
      it "should have an allowing_edit_by? method" do
        @folder.should respond_to(:allowing_edit_by?)
      end
      it "should allow a user to edit" do
        @editor.can_edit!(@folder)
        @folder.should be_allowing_edit_by(@editor)
      end
      it "should DISallow a user from editing" do
        @unauthorized_editor = Factory(:user, :email => Factory.next(:email))
        @unauthorized_editor.can_edit!(@folder)
        @unauthorized_editor.cannot_edit!(@folder)
        @folder.should_not be_allowing_edit_by(@unauthorized_editor)
      end 
      it "should include the user in the editors array" do
        @editor.can_edit!(@folder)
        @folder.editors.should include(@editor)
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
