require 'dry-validation'
require 'sequel'

PHONE_REGEX = /\A\+?[\ \d]*\z/
EMAIL_REGEX = /\A[\w \.]+@[\w \.]+\z/

VALIDATOR = Dry::Validation.Schema do
  required(:name).filled

  required(:email).filled(format?: EMAIL_REGEX)

  required(:age).maybe(:int?)

  required(:phone_number).value(format?: PHONE_REGEX)
end

DB = Sequel.sqlite

DB.create_table :contacts do
  primary_key :id
  String :name
  String :phone_number
  String :age
  String :email
end

class Contact < Sequel::Model
end

def add_person(name, phone_number, age, email)
  errors = VALIDATOR.call(name: name, phone_number: phone_number, age: age, email: email).messages
  if errors.any?
    puts 'This errors prohibited this contact from being saved:'
    errors.each_with_index do |error_hash, index|
      indexplusone = index + 1
      puts "#{indexplusone}) #{error_hash.first} - #{error_hash[1].first}"
    end
  else
    Contact.create(name: name, phone_number: phone_number, age: age, email: email)
  end
end

def find_by_name(name)
  Contact.find(name: name)
end

def find_by_column(column_name, value)
  DB.fetch("SELECT * FROM contacts WHERE #{column_name} LIKE ?", value) do |row|
    puts row
  end
end

add_person('Michał', '+48 600311911', '21', 'mbronek7@gmail.com')