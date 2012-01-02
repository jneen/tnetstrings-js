exports.TNETS = require('./lib/tnetstrings.js').TNETS,
exports.version = JSON.parse(require('fs').readFileSync(__dirname + '/package.json')).version;
