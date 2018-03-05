require 'awesome_print'
require 'tiny_tds'
server = 'kapbd.database.windows.net'
database = 'Kurs'
username = 'mbronek7@kapbd'
password = 'zaq1@WSX'
client = TinyTds::Client.new username: username, password: password, 
    host: server, port: 1433, database: database, azure: true

puts "\nZad5 \n \n"

tsql = 
"
SELECT SalesLT.Customer.LastName, SalesLT.Customer.FirstName, SUM(SalesLT.SalesOrderDetail.UnitPriceDiscount) AS TotalSave
FROM ((SalesLT.Customer
INNER JOIN SalesLT.SalesOrderHeader ON SalesLT.SalesOrderHeader.CustomerID = SalesLT.Customer.CustomerID)
INNER JOIN SalesLT.SalesOrderDetail ON SalesLT.SalesOrderDetail.SalesOrderID = SalesLT.SalesOrderHeader.SalesOrderID )
GROUP BY SalesLT.Customer.LastName,SalesLT.Customer.FirstName 
ORDER BY SUM(SalesLT.SalesOrderDetail.UnitPriceDiscount) DESC
"
result = client.execute(tsql)
result.each do |row|
    puts row
end


