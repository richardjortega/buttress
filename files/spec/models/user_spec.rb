require 'spec_helper'

describe User do
  
  before { @user = User.new }

  context "Validation Checks" do

    it { should respond_to :first_name }
    it { should respond_to :last_name }
    it { should respond_to :email }
    it { should respond_to :password }

    it { should validate_presence_of(:first_name) }
    it { should_not allow_value("a"*51).for(:first_name) }
    
    it { should validate_presence_of(:last_name) }
    it { should_not allow_value("z"*51).for(:last_name) }

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

  end

  context "Relationships" do
  end

  context "Class Methods" do
    subject { User }
    it { should respond_to(:search) }
  end

  context "Instance Methods" do
  end

end