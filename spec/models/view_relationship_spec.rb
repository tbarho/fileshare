require 'spec_helper'

describe ViewRelationship do
  before(:each) do
    @owner = Factory(:user)
    @folder = @owner.folders.create!(:name => "Sample Folder")

    @viewer = Factory(:user, :email => Factory.next(:email))

    @view_relationship = @folder.view_relationships.build(:user_id => @viewer.id)
  end

  it "should create a new instance given valid attributes" do
    @view_relationship.save!
  end

  describe "accessor methods" do
    before(:each) do
      @view_relationship.save
    end
    it "should have a user attribute" do
      @view_relationship.should respond_to(:user)
    end
    it "should have the right user" do
      @view_relationship.user.should == @viewer
    end
    it "should have a viewable attribute" do
      @view_relationship.should respond_to(:viewable)
    end
    it "should have the right viewable resource" do
      @view_relationship.viewable.should == @folder
    end
  end

  describe "validations" do
    it "should require a user_id" do
      @view_relationship.user_id = nil
      @view_relationship.should_not be_valid
    end
    it "should require a viewable_id (polymorphic)" do
      @view_relationship.viewable_id = nil
      @view_relationship.should_not be_valid
    end
    it "should require a viewable_type (polymorphic)" do
      @view_relationship.viewable_type = nil
      @view_relationship.should_not be_valid
    end
    it "should reject the owner's user_id" do
      @view_relationship.user_id = @owner.id
      @view_relationship.should_not be_valid
    end
    it "should reject duplicate entries" do
      @existing_relationship = @folder.view_relationships.create(:user_id => @viewer.id)
      @view_relationship.should_not be_valid
    end
  end

end
