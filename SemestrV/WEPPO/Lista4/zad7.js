const readline = require('readline');
const fs = require('fs');

const MaxRequestOccurencyByIp = (myArray) =>
  myArray.reduce(
    (a, b, i, arr) =>
    (arr.filter(v => v === a).length >= arr.filter(v => v === b).length ? a : b),
    null)

function removeElement(nums, val) {
  for (let i = nums.length - 1; i >= 0; i--) {
    if (nums[i] == val) {
      nums.splice(i, 1);
    }
  }
};

(async function () {
  const rl = readline.createInterface({
    input: fs.createReadStream('server.txt')
  });

  let IPs = []
  rl.on('line', (line) => {
    let host = line.split(" ")[0]
    IPs.push(host)
  });
  rl.on('close', () => {
    for (var i = 1; i <= 3; ++i) {
      mostStr = MaxRequestOccurencyByIp(IPs)
      console.log(i + " - " + mostStr)
      removeElement(IPs, mostStr)
    }
  })
})();