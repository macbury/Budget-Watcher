require 'spec_helper'

describe User do
  it { should have_many(:transactions) }
  it { should have_many(:accounts) }
  
  it "should create accounts for user" do
    user = build(:user)
    user.save.should be(true)
    user.accounts.count.should eq(2)
    user.accounts.sum(:balance_subunit).should eq(0.00)
  end

end
