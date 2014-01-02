var express = require('express');
var app = express();
app.listen(process.env.PORT || 8000);
app.use(express.bodyParser());
app.use(function(req,res,next){
	console.log('\n' + req.method + ' ' + req.url);
	next();
});
app.get('/', function(req, res) {
	res.sendfile('index.html');
});
//app.use(express.directory('/'));
app.use(express.static(__dirname));
