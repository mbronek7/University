require "sequel"

DB = Sequel.sqlite()

DB.create_table :groups do
  primary_key :id
  foreign_key :contact_id, :contacts
  String :name
end

DB.create_table :contacts do
  primary_key :id
  foreign_key :group_id, :groups
  String :name
  String :phone_number
end

DB.create_table(:contacts_groups) do
  foreign_key :contact_id, :contacts, key: :id
  foreign_key :group_id, :groups, key: :id, index: true
  primary_key [:contact_id, :group_id]
end

class Contact < Sequel::Model
  many_to_many :groups
end

class Group < Sequel::Model
  many_to_many :contacts
end

def add_person(name, phone_number,group_names)
  new_contact = Contact.create(name: name, phone_number: phone_number)
  group_names.each do |name|
    g = Group.find(name: name)
    a = Group.create(name: name) if g.nil?
    new_contact.add_group(a)
  end
end

def find_by_name(name)
  Contact.find(name: name)
end

def contact_groups(contact_name)
  contact = find_by_name(contact_name)
  contact.groups
end

def all_groups
  Group.each do |x|
    p x.name
  end
end

def find_by_group(name)
  Group.find(name: name).contacts
end
