require 'spec_helper'

describe Importer do
  
  4.times do |index|
    file = "#{::Rails.root}/spec/factories/pekaoarchiwum/#{index+1}.txt"
    it "should load #{file} for pekao24" do
      importer = Importer.new(file, :pekao24)

      transactions = []
      importer.parse do |transaction|
        transactions << transaction
        transaction.name.should_not         eq(nil)
        transaction.currency.should_not     eq(nil)
        transaction.amount.should_not       eq(nil)
        transaction.publish_at.should_not   eq(nil)
        transaction.publish_at.class.should eq(Date)
      end
    end
  end
end
