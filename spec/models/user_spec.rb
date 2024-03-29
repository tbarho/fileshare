require 'spec_helper'

describe User do
  before(:each) do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com",
      :password => "testpassword",
      :password_confirmation => "testpassword"
    }
  end
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  it "should not allow names longer than 51 chars" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  it "should require an email" do
    no_name_user = User.new(@attr.merge(:email => ""))
    no_name_user.should_not be_valid
  end
  it "should allow valid email addresses" do
    addresses = %w[user@example.com THE_USER@my.example.net a.user@example.co]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  it "should not allow invalid email addresses" do
    addresses = %w[user@example,com THE_USER_my.example.net a.user@example.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  it "should not allow duplicate email addresses" do
    User.create!(@attr)
    user_with_same_email = User.new(@attr)
    user_with_same_email.should_not be_valid
  end
  it "should not allow duplicate email addresses with different cases" do
    upper_cased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upper_cased_email))
    user_with_same_email = User.new(@attr)
    user_with_same_email.should_not be_valid
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
    it "should require a matching password" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    it "should reject short passwords" do
      short_password = "a" * 5
      User.new(@attr.merge(:password => short_password, :password_confirmation => short_password)).should_not be_valid
    end
    it "should reject long passwords" do
      long_password = "a" * 41
      hash = @attr.merge(:password => long_password, :password_confirmation => long_password)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the passwords do not match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end
      it "should return nil on email does not exist" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end
      it "should return the user on email/password match" do
        matched_user = User.authenticate(@attr[:email], @attr[:password])
        matched_user.should == @user
      end
    end
  end

  describe "resource priveledges" do
    before(:each) do
      @owner = Factory(:user)
      @resource = @owner.folders.create(:name => "Sample Folder")
    end

    describe "viewing" do
      before(:each) do
        @view_user = Factory(:user, :email => Factory.next(:email))
        @view_user.can_view!(@resource)
      end
      it "should have a can_view! method" do
        @view_user.should respond_to(:can_view!)
      end
      it "should have a viewing? method" do
        @view_user.should respond_to(:viewing?)
      end
      it "should allow a user to view the resource" do
        @view_user.should be_viewing(@resource)
      end
      it "should have a cannot_view! method" do
        @view_user.should respond_to(:cannot_view!)
      end
      it "should prohibit the user from viewing the resource" do
        @view_user.cannot_view!(@resource)
        @view_user.should_not be_viewing(@resource)
      end
    end

    describe "editing" do
      before(:each) do
        @edit_user = Factory(:user, :email => Factory.next(:email))
        @edit_user.can_edit!(@resource)
      end
      it "should have a can_edit! method" do
        @edit_user.should respond_to(:can_edit!)
      end
      it "should have a editing? method" do
        @edit_user.should respond_to(:editing?)
      end
      it "should allow a user to edit the resource" do
        @edit_user.should be_editing(@resource)
      end
      it "should have a cannot_edit! method" do
        @edit_user.should respond_to(:cannot_edit!)
      end
      it "should prohibit the user from editing the resource" do
        @edit_user.cannot_edit!(@resource)
        @edit_user.should_not be_editing(@resource)
      end
    end
  end
end
