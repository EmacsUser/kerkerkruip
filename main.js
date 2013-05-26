/*

Kerkerkruip build server
========================

Copyright (c) 2013 Dannii Willis
BSD licenced
https://github.com/i7/kerkerkruip

*/

var express = require( 'express' );
var request = require( 'request' );
var config = require( './config.json' );

var data = {
	latest: 'Unknown',
	lateststable: 'Unknown',
};

// Add auto gzipping to the server
var app = express();
app.use( express.compress() );

// The front page
app.get( '/', function( req, res )
{
	res.send( '<!doctype html><title>Kerkerkruip build server</title><h1>Kerkerkruip build server</h1>' + 
		'<p>Latest commit: <a href="https://github.com/i7/kerkerkruip/commit/' + data.latest + '">' + data.latest + '</a>'
	);
});

// Receive a commit hook
app.all( '/hook', function( req, res )
{
	update();
	res.send( 'OK' );
});

// Use the API to get the latest commit
function update()
{
	request( {
		url: 'https://api.github.com/repos/' + config.owner + '/' + config.project + '/commits',
		headers: { 'User-Agent': 'Kerkerkruip/1.0' },
	}, function( error, response, body )
	{
		var json = JSON.parse( body );
		data.latest = json[0].sha.substr( 0, 8 );
	});
}

// Start us up
var port = process.env.PORT || 3000;
app.listen( port );
console.log( 'Kerkerkruip server started on port: ' + port );
update();