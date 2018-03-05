require 'awesome_print'
require 'tiny_tds'
server = 'kapbd.database.windows.net'
database = 'Kurs'
username = 'mbronek7@kapbd'
password = 'zaq1@WSX'
client = TinyTds::Client.new username: username, password: password, 
    host: server, port: 1433, database: database, azure: true

puts "\nZad2 \n \n"

tsql =
"
SELECT SalesLT.ProductModel.Name AS ProductName, COUNT(SalesLT.Product.ProductModelID) AS Quantity
FROM  SalesLT.ProductModel
INNER JOIN SalesLT.Product ON SalesLT.Product.ProductModelID = SalesLT.ProductModel.ProductModelID
GROUP BY SalesLT.ProductModel.Name
HAVING COUNT(SalesLT.Product.ProductModelID) > 1;
"
result = client.execute(tsql)
result.each do |row|
    puts  row
end


