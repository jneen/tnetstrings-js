exports.TNETS = require('./lib/tnetstrings.js').TNETS
try{
    exports.version = JSON.parse(require('fs').readFileSync(__dirname + '/package.json')).version;
}catch{
    console.warn("No fs module!");
}


