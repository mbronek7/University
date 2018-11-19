process.stdin.setEncoding('utf8');
process.stdout.write(`Serwus, jak masz na imię :)\n`);
process.stdin.on('readable', () => {
  const name = process.stdin.read();
  if (name !== null) {
    process.stdout.write(`Witaj ${name}`);
    process.exit();
  }
});