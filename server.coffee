express = require "express"
app = express()
port = 8000
if process.env.NODE_ENV == 'production'
	port = 80
else
	port = process.env.PORT || port
console.log "listening on port #{port}"
app.listen port
app.use express.bodyParser()

# primitive logger
app.use (req,res,next) ->
	console.log "\n #{req.method} #{req.url}"
	next()
	return null

app.get '/', (req, res) ->
	res.sendfile "index.html"
	return null

# static file serving
app.use express.static __dirname

# backstop logger
#app.all "*", (req, res, next) ->
#	console.log "  request ignored"
#	return null
