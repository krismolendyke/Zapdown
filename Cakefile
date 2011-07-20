{exec} = require 'child_process'

task 'run', 'Run the Zapdown server.', ->
    console.log "Running #{process.cwd()}/production/src/server.coffee"
    exec "zappa -w #{process.cwd()}/production/src/server.coffee", (err, stdout, stderr) ->
        if err then console.log "Uh-oh: #{err}"
        else
            console.log stderr
            console.log stdout
