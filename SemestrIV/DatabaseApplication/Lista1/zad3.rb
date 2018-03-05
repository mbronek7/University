require 'awesome_print'
require 'tiny_tds'
server = 'kapbd.database.windows.net'
database = 'Kurs'
username = 'mbronek7@kapbd'
password = 'zaq1@WSX'
client = TinyTds::Client.new username: username, password: password, 
    host: server, port: 1433, database: database, azure: true

puts "\nZad3 \n \n"

tsql =
"
SELECT SalesLT.Address.City, COUNT(SalesLT.Customer.CustomerID) AS CustomerCount, COUNT(DISTINCT SalesLT.Customer.SalesPerson) AS SalesPerson
FROM ((SalesLT.Address 
INNER JOIN SalesLT.CustomerAddress ON SalesLT.Address.AddressID = SalesLT.CustomerAddress.AddressID)
INNER JOIN SalesLT.Customer ON SalesLT.Customer.CustomerID = SalesLT.CustomerAddress.CustomerID)
GROUP BY SalesLT.Address.City
"

result = client.execute(tsql)
result.each do |row|
    puts row
end


