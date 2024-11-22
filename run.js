const fs = require('fs');
const parser = require('./json-parser');

// Read the JSON file
const filePath = 'tests/test7.json';
try {
  const testJson = fs.readFileSync(filePath, 'utf-8'); // Read the file synchronously

  // Parse the JSON
  const result = parser.parse(testJson);
  console.log(result);

  // Get a random key from the parsed object
  const keys = Object.keys(result);
  const randomKey = keys[Math.floor(Math.random() * keys.length)];
  console.log(`Value of random key "${randomKey}":`, result[randomKey]);

  // Write the parsed result to 'Output.txt'
  const data = JSON.stringify(result, null, 2); // Format with 2-space indentation
  fs.writeFileSync('output.json', data, 'utf-8'); // Write the file synchronously

  console.log(`Parsed JSON written to Output.txt`);
} catch (err) {
  console.error('Error:', err.message);
}
