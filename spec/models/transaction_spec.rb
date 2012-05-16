require 'spec_helper'

describe Transaction do
  it { should belong_to(:user) }
  it { should belong_to(:account) }
  it { should validate_presence_of(:description) }
  
  it "should format string amounts to money class" do
    transaction = Transaction.new
    transaction.amount = "10,00"
    transaction.amount.should be_an_instance_of(Money)
  end

  it "should build hash and set transaction type" do
    transaction = create(:transaction)

    transaction.hash_uid.should_not         be(nil)
    transaction.transaction_type.should_not be(nil)
  end

  it "should set outcome type for negative number" do
    transaction = create(:transaction, amount: "- 10,00")
    transaction.transaction_type.should eq(Transaction::Outcome)
  end

  it "should set income type for plus number" do
    transaction = create(:transaction, amount: "+ 10,00")
    transaction.transaction_type.should eq(Transaction::Income)
  end

  it "should set transfer type for new accunt" do
    transaction = build(:transaction, amount: "+ 10,00")
    transaction.base_account = create(:account)
    transaction.should be_valid
    transaction.save
    transaction.transaction_type.should eq(Transaction::Transfer)
  end

  it "should prevent transfer for the same account" do
    transaction = build(:transaction, amount: "+ 10,00")
    account = create(:account)
    transaction.base_account = account
    transaction.account = account
    transaction.should_not be_valid
  end

  it "should not save if is less than 3 character description" do
    transaction = build(:transaction, description: "12")
    transaction.should_not be_valid
  end

  it "should update account balance after CRUD operations" do
    transaction = create(:transaction, amount: "10,00")
    transaction.account.balance.should eq(10)

    transaction.update_attributes amount: "-10.00"
    transaction.account.balance.should eq(-10)

    transaction2 = create(:transaction, amount: "10,00", account_id: transaction.account_id)
    transaction2.account.balance.should eq(0)

    transaction2.save
    transaction2.account.balance.should eq(0)

    transaction2.destroy

    account = Account.find(transaction.account_id)
    account.balance.should eq(-10)
  end

  it "should transfer money from one account to another after crud" do
    wallet  = create(:account)
    account = create(:account)

    transaction = build(:transaction, amount: "10,00")
    transaction.account = account
    transaction.save

    wallet.reload.balance.should  eq(0)
    account.reload.balance.should eq(10)

    transaction.save
    wallet.reload.balance.should  eq(0)
    account.reload.balance.should eq(10)

    transaction.account = wallet
    transaction.save

    account.reload
    wallet.reload.balance.should  eq(10)
    account.reload.balance.should eq(0)

    transaction.save
    wallet.reload.balance.should  eq(10)
    account.reload.balance.should eq(0)

    transaction.account = account
    transaction.save

    wallet.reload.balance.should  eq(0)
    account.reload.balance.should eq(10)

    transaction.update_attributes amount: "-10,00"
    wallet.reload.balance.should  eq(0)
    account.reload.balance.should eq(-10)

    5.times do 
      transaction.save

      wallet.reload.balance.should  eq(0)
      account.reload.balance.should eq(-10)
    end
  end

  it "should update account balance after CRUD operations for transfer operation" do
    base_account    = create(:account)
    target_account  = create(:account)
    another_account = create(:account)

    base_account.balance.should    eq(0)
    target_account.balance.should  eq(0)
    another_account.balance.should eq(0)

    transaction = create(:transaction, amount: "10,00", base_account_id: base_account.id, account_id: target_account.id)
    base_account.reload.balance.should   eq(-10)
    target_account.reload.balance.should eq(10)

    transaction.update_attributes amount: "-5,00"

    base_account.reload.balance.should   eq(5)
    target_account.reload.balance.should eq(-5)

    transaction.update_attributes account_id: another_account.id

    base_account.reload.balance.should    eq(5)
    target_account.reload.balance.should  eq(0)
    another_account.reload.balance.should eq(-5)

    transaction.update_attributes account_id: target_account.id, amount: "-8,00"

    base_account.reload.balance.should    eq(8)
    target_account.reload.balance.should  eq(-8)
    another_account.reload.balance.should eq(0)

    transaction.update_attributes account_id: base_account.id, amount: "3,00", base_account_id: target_account.id
    target_account.reload.balance.should  eq(-3)
    base_account.reload.balance.should    eq(3)
    another_account.reload.balance.should eq(0)
  end
end
