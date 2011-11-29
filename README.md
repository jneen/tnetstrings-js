# tnetstrings.js

[tnetstrings](http://tnetstrings.org/) is a serialization format similar to JSON, but optimized for communication over streams.  This is a serialization library for javascript, usable both in the browser and with CommonJS.

## Usage

The interface to `tnetstrings.js` is the variable `TNETS`, which is exposed as a global variable in the browser, and as `require('tnetstrings').TNETS` in CommonJS.  It is API-compatible with the `JSON` object, as so:

``` javascript
TNETS.stringify('Hello, World!') // => "13:Hello, World!,"
TNETS.parse('13:Hello, World!,') // => "Hello, World!"
```

In addition, TNETS exposes the method `parseChunk`, which returns the value and the remaining part of the string.

``` javascript
TNETS.parseChunk('13:Hello, World!,also some other stuff') // ["Hello, World!", "also some other stuff"]
```

Enjoy!
