var fs = require('fs');
var http2 = require('http2');
(async function () {
  var pfx = await fs.promises.readFile('mycert.pfx');
  var server = http2.createSecureServer({
      pfx: pfx,
      passphrase: 'bronio'
    },
    (req, res) => {
      res.setHeader('Content-type', 'text/html; charset=utf-8');
      res.end(`hello world ${new Date()}`);
    });
  server.listen(3000);
  console.log('started');
})();