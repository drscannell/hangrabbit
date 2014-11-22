express = require "express"
path = require "path"
app = express()
port = 3001
app.listen port, ->
	console.log "Listening on port #{port}"
	return null

app.use express.bodyParser()

# primitive logger
app.use (req,res,next) ->
	console.log "#{req.method} #{req.url}"
	next()
	return null

staticfolder = path.resolve __dirname, "../static"

app.get '/', (req, res) ->
	res.sendfile "#{staticfolder}/index.html"
	return null

app.get '/js/client.js', (req, res) ->
	res.sendfile "#{__dirname}/client.js"
	return null

# static file serving
app.use express.static staticfolder

