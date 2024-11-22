const fs = require('fs')

const parser = require('./json-parser');

const testJson = `
{
  "key1": -42123,
  "key2": 3.14,
  "key3": 3.1415,
  "key4": true,
  "key5": null,
  "key6": [1, 2, 3.5]
}`;

try {
  const result = parser.parse(testJson);
  console.log(result);
  console.log(result['key1']);

    // Write data in 'Output.txt' .
    data = JSON.stringify(result);
    fs.writeFile('Output.txt', data, 'utf-8', (err) => {

        // In case of a error throw err.
        if (err) throw err;
    })
} catch (err) {
  console.error('Parse error:', err.message);
}