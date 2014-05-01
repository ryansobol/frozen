{spawn} = require 'child_process'

launch = (cmd, args = [], callback) ->
  app = spawn cmd, args, { stdio: 'inherit' }
  (app.on 'exit', (status) -> callback() if status is 0) if callback?

build = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false

  args = ['-c', '-o', 'lib', 'src']
  args.unshift '-w' if watch

  launch 'node_modules/.bin/coffee', args, callback

task 'build', 'Compile the source files', ->
  build()

task 'watch', 'Recompile the source files when modified', ->
  build true

task 'test', 'Run the test suite', ->
  build ->
    args = ['--compilers', 'coffee:coffee-script/register', '-R', 'min']
    launch 'node_modules/.bin/mocha', args

task 'docs', 'Generate the documentation', ->
  launch 'node_modules/.bin/docco', ['src/frozen.coffee']
