require 'awesome_print'
require 'tiny_tds'
server = 'kapbd.database.windows.net'
database = 'Kurs'
username = 'mbronek7@kapbd'
password = 'zaq1@WSX'
client = TinyTds::Client.new username: username, password: password, 
    host: server, port: 1433, database: database, azure: true

puts "\nZad4 \n \n"

tsql = 

"
SELECT DISTINCT c.Name Category, p.Name Product
FROM ((SalesLT.ProductCategory c
JOIN SalesLT.ProductCategory c2 ON c.ProductCategoryID = c2.ParentProductCategoryID)
JOIN SalesLT.Product p ON c.ProductCategoryID = p.ProductCategoryID)
"

result = client.execute(tsql)
result.each do |row|
    puts row
end


