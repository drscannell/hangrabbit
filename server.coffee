express = require "express"
app = express()
app.listen process.env.PORT || 8000
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
app.all "*" (req, res, next) ->
	console.log "  request ignored"
	return null
