# frozen_string_literal: true

require "dry-validation"
require "sequel"

##
# This is the regex for phone numbers
PHONE_REGEX = /\A\+?[\ \d]*\z/
##
# This is the regex for email addresses
EMAIL_REGEX = /\A[\w \.]+@[\w \.]+\z/

##
# This is the validator to check the correctness of +contact+ params
VALIDATOR = Dry::Validation.Schema do
  required(:name).filled

  required(:email).filled(format?: EMAIL_REGEX)

  required(:age).maybe(:int?)

  required(:phone_number).value(format?: PHONE_REGEX)
end

##
# This represents a database
DB = Sequel.sqlite

DB.create_table :contacts do
  primary_key :id
  String :name
  String :phone_number
  String :age
  String :email
end

##
# This class represents an Contact model in database
class Contact < Sequel::Model
end

##
# Creates a new contact based on +name+, +phone_number+, +age+, +email+ params
#
# If the +VALIDATOR+ does not success no contact is created.
#
# Else the new contact is being created and saved into the database

def add_person(name, phone_number, age, email)
  errors = VALIDATOR.call(name: name, phone_number: phone_number, age: age, email: email).messages
  if errors.any?
    puts "This errors prohibited this contact from being saved:"
    errors.each_with_index do |error_hash, index|
      indexplusone = index + 1
      puts "#{indexplusone}) #{error_hash.first} - #{error_hash[1].first}"
    end
  else
    Contact.create(name: name, phone_number: phone_number, age: age, email: email)
  end
end

##
# Finds +contact+ by its name

def find_by_name(name)
  Contact.find(name: name)
end

##
# Finds +contact+ by selected column e.g. *age* or *email* the column is gived in param by user

def find_by_column(column_name, value)
  DB.fetch("SELECT * FROM contacts WHERE #{column_name} LIKE ?", value) do |row|
    puts row
  end
end

add_person("Michał", "+48 600311911", "21", "mbronek7@gmail.com")
