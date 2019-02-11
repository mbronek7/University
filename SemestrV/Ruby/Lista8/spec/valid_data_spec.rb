require 'rspec'
require_relative '../zad2.rb'

describe VALIDATOR do
  let!(:name) { "Michał" }
  let!(:phone_number) { "+48 600311911" }
  let!(:age) { 21 }
  let!(:email) { "mbronek7@gmail.com" }

  it "should successfuly validate input" do
    errors = described_class.call(name: name, phone_number: phone_number, age: age, email: email).messages
    errors.should be_empty
  end

  let!(:age2) { "21" }
  it "should not successfuly validate input" do
    errors = described_class.call(name: name, phone_number: phone_number, age: age2, email: email).messages
    errors.should_not be_empty
  end

  let!(:email2) { "" }
  it "should validate presence of email" do
    errors = described_class.call(name: name, phone_number: phone_number, age: age, email: email2).messages
    errors.should_not be_empty
  end

  let!(:name2) { "" }
  it "should validate presence of email" do
    errors = described_class.call(name: name2, phone_number: phone_number, age: age).messages
    errors.should_not be_empty
  end
end
