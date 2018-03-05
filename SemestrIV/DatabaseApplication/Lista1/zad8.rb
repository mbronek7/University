require 'awesome_print'
require 'tiny_tds'
server = 'kapbd.database.windows.net'
database = 'Kurs'
username = 'mbronek7@kapbd'
password = 'zaq1@WSX'
client = TinyTds::Client.new username: username, password: password, 
    host: server, port: 1433, database: database, azure: true

puts "\nZad8 \n \n"

tsql = 
"
ALTER TABLE SalesLT.Customer
ADD 
     CreditCardNumber varchar(255) DEFAULT '00000000000000000000' NOT NULL
     CONSTRAINT CHK_CreditCardNumber CHECK (DATALENGTH([CreditCardNumber]) >= 20)
"

result = client.execute(tsql)
result.each do |row|
    puts row
end


