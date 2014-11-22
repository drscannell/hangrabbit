server:
	mkdir -p ./js
	coffee -co ./js ./src/
	node ./js/server.js
