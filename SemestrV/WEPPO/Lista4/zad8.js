const util = require('util');
const fs = require('fs');

const readFileAsync = util.promisify(fs.readFile);

function getFile(fileName, type) {
  return new Promise(function (resolve, reject) {
    fs.readFile(fileName, type, (err, data) => {
      if (err) {
        reject(err);
      }
      resolve(data);
    })
  });
}
// PO STAREMU
getFile("data.txt", {
    encoding: 'utf8'
  })
  .then((text) => {
    console.log(text);
  })
  .catch((err) => {
    console.log('ERROR:', err);
  });

readFileAsync("data.txt", {
    encoding: 'utf8'
  })
  .then((text) => {
    console.log(text);
  })
  .catch((err) => {
    console.log('ERROR:', err);
  });

fs.promises.readFile("data.txt", {
    encoding: 'utf8'
  })
  .then(r => console.log(r))
  .catch((err) => {
    console.log('ERROR:', err);
  });
// PO NOWEMU
async function new1() {
  try {
    const text = await readFileAsync("data.txt", {
      encoding: 'utf8'
    });
    console.log(text);
  } catch (err) {
    console.log('ERROR:', err);
  }
}
async function new2() {
  try {
    const text = await getFile("data.txt", {
      encoding: 'utf8'
    });
    console.log(text);
  } catch (err) {
    console.log('ERROR:', err);
  }
}
new1();
new2();