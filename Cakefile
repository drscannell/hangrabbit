{exec} = require 'child_process'
fs = require 'fs'
path = require 'path'

# app-specific paths
SRC_PATH = "./src"
BUILD_PATH = "./js"

# ------------ helper ------------

runscript = (cmd, callback) ->
    child = exec cmd
    child.stdout.on 'data', (data) -> console.log data.trim()
    child.stderr.on 'data', (data) -> console.log data.trim()
    child.on 'exit', (status) ->
        callback?()

# ------------ subtasks ------------

watchCoffee = (srcPath, buildPath, callback) ->
	fs.watch srcPath, {persistent:false}, (event, filename) ->
		if path.extname(filename) is ".coffee"
			buildCoffee path.join(srcPath,filename), buildPath
	callback?()

mkdir = (dirPath, callback) ->
	fs.exists dirPath, (exists) ->
		if not exists
			callback?()
		else
			fs.mkdir dirPath, callback

buildCoffee = (srcPath, buildPath, callback) ->
	mkdir buildPath, ->
		cmd = "coffee -co #{buildPath} #{srcPath}"
		console.log cmd
		runscript cmd, callback

startServer = (callback) ->
	cmd = "node js/server.js"
	runscript cmd, callback

# ------------ command line tasks ------------

task 'dev-server', 'run development server', (options) ->
	buildCoffee SRC_PATH, BUILD_PATH, ->
		watchCoffee SRC_PATH, BUILD_PATH, ->
			startServer()

task 'prod-server', 'run production server', (options) ->
	buildCoffee SRC_PATH, BUILD_PATH, ->
		startServer()
