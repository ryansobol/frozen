{spawn} = require 'child_process'

build = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false

  options = ['-c', '-o', 'lib', 'src']
  options.unshift '-w' if watch

  coffee = spawn 'node_modules/.bin/coffee', options
  coffee.stdout.pipe(process.stdout)
  coffee.stderr.pipe(process.stderr)
  coffee.on 'exit', (status) ->
    if status is 0 then callback?() else process.exit(status)

task 'build', 'Compile source files', ->
  build()

task 'watch', 'Recompile source files when modified', ->
  build true

task 'test', 'Run the test suite', ->
  build ->
    options = ['--compilers', 'coffee:coffee-script/register', '-R', 'progress']

    mocha = spawn 'node_modules/.bin/mocha', options
    mocha.stdout.pipe(process.stdout)
    mocha.stderr.pipe(process.stderr)
