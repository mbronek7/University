require 'awesome_print'
require 'tiny_tds'
server = 'kapbd.database.windows.net'
database = 'Kurs'
username = 'mbronek7@kapbd'
password = 'zaq1@WSX'
client = TinyTds::Client.new username: username, password: password, 
    host: server, port: 1433, database: database, azure: true

puts "\nZad1 \n \n"

tsql = "SELECT DISTINCT City FROM SalesLT.Address WHERE EXISTS
(SELECT ShipToAddressID FROM SalesLT.SalesOrderHeader WHERE AddressID = ShipToAddressID) ORDER BY City"
result = client.execute(tsql)
result.each do |row|
    puts  row
end


