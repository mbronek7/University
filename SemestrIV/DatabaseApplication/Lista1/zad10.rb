require 'awesome_print'
require 'tiny_tds'
server = 'kapbd.database.windows.net'
database = 'Kurs'
username = 'mbronek7@kapbd'
password = 'zaq1@WSX'
client = TinyTds::Client.new username: username, password: password, 
    host: server, port: 1433, database: database, azure: true

puts "\nZad10 \n \n"

tsql = 
"
CREATE TABLE  Test
(
 id int IDENTITY(1000,10),
 first_name varchar (20),
 last_name varchar (30)
)

INSERT Test
(first_name,last_name)
VALUES
('Michal','Bronikowski'),
('Czeslaw','Czapka');

"

result = client.execute(tsql)
result.each do |row|
    puts row
end


