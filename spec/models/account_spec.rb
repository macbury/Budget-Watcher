require 'spec_helper'

describe Account do
  it { should belong_to(:user) }
  it { should have_many(:transactions) }
  it { should validate_presence_of(:name) }
  
  it "should format plus string amounts to money class" do
    account = Account.new
    account.balance = "10,00"
    account.balance.should be_an_instance_of(Money)
    account.balance_subunit.should eq(1000)
  end
  it "should format minus string amounts to money class" do
    account = Account.new
    account.balance = "-10,00"
    account.balance.should be_an_instance_of(Money)
    account.balance_subunit.should eq(-1000)
  end
end
