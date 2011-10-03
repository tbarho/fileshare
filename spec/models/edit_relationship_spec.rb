require 'spec_helper'

describe EditRelationship do
  before(:each) do
    @owner = Factory(:user)
    @folder = @owner.folders.create!(:name => "Sample Folder")
    @editor = Factory(:user, :email => Factory.next(:email))

    @edit_relationship = @folder.edit_relationships.build(:user_id => @editor.id) 
  end

  it "should create a new instance given valid attributes" do
    @edit_relationship.save!
  end

  describe "accessor methods" do
    before(:each) do
      @edit_relationship.save
    end
    it "should have a user attribute" do
      @edit_relationship.should respond_to(:user)
    end
    it "should have the right user" do
      @edit_relationship.user.should == @editor
    end
    it "should have a editable attribute" do
      @edit_relationship.should respond_to(:editable)
    end
    it "should have the right editable resource" do
      @edit_relationship.editable.should == @folder
    end
  end

  describe "validations" do
    it "should require a user_id" do
      @edit_relationship.user_id = nil
      @edit_relationship.should_not be_valid
    end
    it "should require an editable_id (polymorphic)" do
      @edit_relationship.editable_id = nil
      @edit_relationship.should_not be_valid
    end
    it "should require an editable_type (polymorphic)" do
      @edit_relationship.editable_type = nil
      @edit_relationship.should_not be_valid
    end
    it "should reject the owner's user_id" do
      @edit_relationship.user_id = @owner.id
      @edit_relationship.should_not be_valid
    end
    it "should reject duplicate entries" do
      @existing_relationship = @folder.edit_relationships.create(:user_id => @editor.id)
      @edit_relationship.should_not be_valid
    end
  end
end
