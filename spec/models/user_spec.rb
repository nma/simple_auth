require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com", 
      :password => "fake123", :password_confirmation => "fake123"}
    @user = User.new(@attr)
  end

  subject{@user}

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar..com]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    user = User.create!(@attr)
    user.save
    user_with_duplicate_email = user.dup
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    user = User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr) 
    user_with_duplicate_email.should_not be_valid
  end

  # new style of tests, technical debt, change to one preferered type (above, below) later on
  describe "email with mixed case" do
    let(:mixed_email) { "AusR@EmAil.coM" }

    it "should save email as lower case" do
      @user.email = mixed_email
      @user.save
      expect(@user.reload.email).to eq mixed_email.downcase
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password is mismatched" do
    before do
      @user.password = "mismatch"
    end
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) {User.find_by(:email => @user.email)}

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password)}
    end

    describe "with invalid password" do
      let(:user_with_invalid_password) { found_user.authenticate("invalid") }

      # it and specify are synonyms, just another way when it sounds awkward in the test context 
      it { should_not eq user_with_invalid_password }
      specify { expect(user_with_invalid_password).to be_false }
    end
  end
end
