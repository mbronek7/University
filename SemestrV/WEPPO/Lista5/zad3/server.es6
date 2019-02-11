var fs = require('fs');
var http = require('http');
(async function () {
  var html = await fs.promises.readFile('index.html', 'utf-8');
  var server = http.createServer(
    (req, res) => {
      res.setHeader('Content-disposition', 'attachment; filename=test.html');
      res.end(html);
    });
  server.listen(3000);
  console.log('started');
})();