{spawn, exec} = require 'child_process'

task 'build', ->
  run 'coffee --bare -o lib src/*.coffee'

task 'minify', ->
  invoke 'build'
  run 'uglifyjs -o lib/tnetstrings.min.js lib/tnetstrings.js --lift-vars'

task 'test', ->
  run 'expresso test/*.test.coffee'

task 'package', ->
  invoke 'minify'
  invoke 'test'
  run 'npm pack .'

run = (args...) ->
  for a in args
    switch typeof a
      when 'string' then command = a
      when 'object'
        if a instanceof Array then params = a
        else options = a
      when 'function' then callback = a

  command += ' ' + params.join ' ' if params?
  cmd = spawn '/bin/sh', ['-c', command], options
  cmd.stdout.on 'data', (data) -> process.stdout.write data
  cmd.stderr.on 'data', (data) -> process.stderr.write data
  process.on 'SIGHUP', -> cmd.kill()
  cmd.on 'exit', (code) -> callback() if callback? and code is 0
