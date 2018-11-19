const fs = require('fs');


function ReadFilePromise(file) {
  return new Promise(function (resolve, reject) {
    fs.open(file, 'r', (err, data) => {
      if (err) {
        if (err.code === 'ENOENT') {
          reject('File: ' + file + ' does not exist');
        }
      }
      resolve(fs.readFileSync(data).toString());
    });
  });
};

(async function () {
  try {
    var data = await ReadFilePromise(process.argv.slice(2).toString())
    console.log(data);
  } catch (e) {
    console.log(e);
  }
})();