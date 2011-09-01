assert = require 'assert'
# console.log inspect(require 'expresso')
{TNETS} = require '../src/tnetstrings'

test = (name, fn) ->
  exports["test #{name}"] = fn

test 'parsing null', ->
  assert.isNull TNETS.parse('0:~')

test 'parsing a string', ->
  assert.eql 'abcdefg', TNETS.parse('7:abcdefg,')

test 'parsing true', ->
  assert.eql true, TNETS.parse('4:true!')

test 'parsing false', ->
  assert.eql false, TNETS.parse('5:false!')
  assert.eql false, TNETS.parse('3:abc!') # anything else is false

test 'parsing an integer', ->
  assert.eql 34, TNETS.parse('2:34#')
  assert.eql 0, TNETS.parse('0:#')

test 'parsing a float', ->
  assert.eql 12.34, TNETS.parse('5:12.34^')
  assert.eql 12.0, TNETS.parse('4:12.0^')

test 'parsing an array', ->
  assert.eql [null, 1, "abc"], TNETS.parse('13:0:~1:1#3:abc,]')
  assert.eql [], TNETS.parse('0:]')

test 'parsing an object', ->
  assert.eql {a:1, b:2}, TNETS.parse('16:1:a,1:1#1:b,1:2#}')
  assert.eql {}, TNETS.parse('0:}')
