TNETS = ( ->
  # -*- private methods -*- #
  assert = (test, msg) ->
    throw msg unless test

  # for the love of pete
  if typeof Array.isArray is 'function'
    isArray = Array.isArray
  else
    isArray = (a) -> Object::toString.call(a) == '[object Array]'

  parsePayload = (data) ->
    assert data, "invalid data to parseChunk, it's empty."
    colonIndex = data.indexOf(':')
    assert colonIndex > 0, "invalid length spec"

    length = data.slice(0, colonIndex)
    extra = data.slice(colonIndex + 1)

    assert !/\D/.test(length), "non-numeric characters in length spec"

    length = +length
    payload = extra.slice(0, length)
    payloadType = extra.charAt(length)
    remain = extra.slice(length+1)

    return [payload, payloadType, remain]

  parseArray = (data) ->
    result = []
    while data.length > 0
      [value, data] = parseChunk(data)
      result[result.length] = value

    result

  parsePair = (data) ->
    [key, extra] = parseChunk(data)
    assert extra.length, "Unbalanced dictionary"
    [value, extra] = parseChunk(extra)

    return [key, value, extra]

  parseObject = (data) ->
    result = {}
    while data.length > 0
      [key, value, data] = parsePair(data)
      result[key] = value

    return result

  dumpArray = (arr) ->
    payload = (stringify(el) for el in arr).join('')
    "#{payload.length}:#{payload}]"

  dumpObject = (obj) ->
    # TODO: benchmark this, optimize if necessary
    payload = (stringify(k)+stringify(v) for k, v of obj).join('')
    "#{payload.length}:#{payload}}"

  # -*- public methods -*- #
  parseChunk = (data) ->
    [payload, payloadType, remain] = parsePayload(data)

    value = switch payloadType
      when '#', '^' then +payload
      when '}' then parseObject(payload)
      when ']' then parseArray(payload)
      when '!' then payload == 'true'
      when ',' then payload
      when '~'
        assert payload.length == 0, "payload size must be zero for null"
        null
      else
        assert false, "invalid payload type: "+payloadType

    return [value, remain]

  parse = (data) -> parseChunk(data)[0]

  stringify = (obj, opts) ->
    opts ||= {}

    if !obj?
      return '0:~'

    assert typeof obj isnt 'function', "TNETS can't stringify a function"

    if typeof obj is 'string' or obj instanceof String
      "#{obj.length}:#{obj},"
    else if typeof obj is 'number'
      # test if it's an integer (or close enough)
      type = if Math.floor(obj) is obj and opts.type isnt 'float' then '#' else '^'
      obj = ''+obj
      "#{obj.length}:#{obj}#{type}"
    else if typeof obj is 'boolean'
      obj = ''+obj
      "#{obj.length}:#{obj}!"
    else if isArray(obj)
      dumpArray(obj)
    else
      dumpObject(obj)


  return {parse, parseChunk, stringify}
)()

exports.TNETS = TNETS if typeof exports isnt 'undefined'
