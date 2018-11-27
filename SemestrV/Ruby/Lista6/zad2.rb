require "sequel"
require "date"


DB = Sequel.sqlite()

DB.create_table :plates do
  primary_key :id
  String :name
end

DB.create_table :authors do
  primary_key :id
  String :name
end

DB.create_table :tracks do
  primary_key :id
  String :name
end

DB.create_table :borrows do
  primary_key :id
  String :name
  Date :borrowed_at
end


DB.create_table(:authors_plates) do
  foreign_key :author_id, :authors, key: :id, index: true
  foreign_key :plate_id, :plates, key: :id, index: true
  primary_key [:author_id, :plate_id]
end

DB.create_table(:plates_tracks) do
  foreign_key :track_id, :tracks, key: :id, index: true
  foreign_key :plate_id, :plates, key: :id, index: true
  primary_key [:track_id, :plate_id]
end

DB.create_table(:borrows_plates) do
  foreign_key :borrow_id, :borrows, key: :id, index: true
  foreign_key :plate_id, :plates, key: :id, index: true
  primary_key [:borrow_id, :plate_id]
end

class Plate < Sequel::Model
  many_to_many :authors
  many_to_many :tracks
  many_to_many :borrows
end

class Author < Sequel::Model
  many_to_many :plates
end

class Track < Sequel::Model
  many_to_many :plates
end

class Borrow < Sequel::Model
  many_to_many :plates
end

def add_plate(name, author, tracks)
  new_plate = Plate.create(name: name)
  a = Author.find(name: author)
  a = Author.create(name: author) if a.nil?
  new_plate.add_author(a)
  tracks.each do |track|
    new_track = Track.create(name: track)
    new_plate.add_track(new_track)
  end
end

def add_borrow(plate, name, date)
  new_borrow = Borrow.create(name: name, borrowed_at: date)
  plate.add_borrow(new_borrow)
end

def borrowed_before(days_count)
  days = DateTime.now - days_count
  DB.fetch("SELECT * FROM borrows WHERE borrowed_at <= ?", days) do |row|
    puts "#{row.name} - #{row.plates}"
  end
end