assert = require 'assert'
{TNETS} = require '../src/tnetstrings'

test = (name, fn) ->
  exports["test #{name}"] = fn

test 'stringifying null', ->
  assert.eql '0:~', TNETS.stringify(null)

test 'stringifying a string', ->
  assert.eql '7:abcdefg,', TNETS.stringify('abcdefg')

test 'stringifying true', ->
  assert.eql '4:true!', TNETS.stringify(true)

test 'stringifying false', ->
  assert.eql '5:false!', TNETS.stringify(false)

test 'stringifying an integer', ->
  assert.eql '2:34#', TNETS.stringify(34)
  assert.eql '1:0#', TNETS.stringify(0)

test 'stringifying a float', ->
  assert.eql '5:12.34^', TNETS.stringify(12.34)
  # NB: javascript has weird numbers.
  # There is no internal difference between 12.0 and 12,
  # they're effectively the same.
  # therefore you must pass {type: 'float'} so we know
  # it's actually supposed to be a float.
  # TODO: This doesn't work for floats nested in places,
  # and there's got to be a better way...
  assert.eql '2:12#', TNETS.stringify(12.0)
  assert.eql '2:12^', TNETS.stringify(12.0, type: 'float')

test 'stringifying an array', ->
  assert.eql '13:0:~1:1#3:abc,]', TNETS.stringify([null, 1, "abc"])
  assert.eql '0:]', TNETS.stringify([])

test 'stringifying an object', ->
  assert.eql '16:1:a,1:1#1:b,1:2#}', TNETS.stringify(a: 1, b: 2)
