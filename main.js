/*

Kerkerkruip build server
========================

Copyright (c) 2013 Dannii Willis
BSD licenced
https://github.com/i7/kerkerkruip

*/

/*

TODO:
	OAuth stuff?

*/

var express = require( 'express' );
var flow = require( 'gowiththeflow' );

//var inform7 = require( './inform7.js' );
var update = require( './update.js' );
var util = require( './util.js' );

// Add auto gzipping to the server
var app = express();
app.use( express.compress() );

// The front page
app.get( '/', function( req, res )
{
	res.send(
		'<!doctype html><title>Kerkerkruip build server</title>' + 
		'<h1><a href="https://github.com/i7/kerkerkruip/">Kerkerkruip</a> build server</h1>' + 
		'<p>Latest commit: <a href="https://github.com/i7/kerkerkruip/commit/' + util.data( 'last' ) + '">' + util.data( 'last' ) + '</a>'
	);
});

// Receive a commit hook
app.all( '/hook', function( req, res )
{
	update.update( function(){} );
	res.send( 'OK' );
});

// Start us up
flow()

// Install Inform 7 if needed
/*.seq( function( next )
{
	inform7.install( next );
})*/

.seq( function( next )
{
	update.update( next );
})

.seq( function()
{
	var port = process.env.PORT || 3000;
	app.listen( port );
	console.log( 'Kerkerkruip server started on port: ' + port );
});