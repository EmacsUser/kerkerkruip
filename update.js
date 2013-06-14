/*

Kerkerkruip build server - Update and build
===========================================

Copyright (c) 2013 Dannii Willis
BSD licenced
https://github.com/i7/kerkerkruip

*/

var exec = require( 'child_process' ).execFile;
var flow = require( 'gowiththeflow' );
var fs = require( 'fs' );
var mkdirp = require( 'mkdirp' );
var path = require( 'path' );
var request = require( 'request' );

var util = require( './util.js' );

request = request.defaults( { headers: { 'User-Agent': 'Kerkerkruip/1.0' } } );

// Use the API to get the latest commit
var update = exports.update = function( callback )
{
	request( 'https://api.github.com/repos/i7/kerkerkruip/commits', function( error, response, body )
	{
		var json = JSON.parse( body );
		var oldlast = util.data( 'last' );
		var last = util.data( 'last', json[0].sha.substr( 0, 7 ) );
		
		if ( /*oldlast != last*/ 1 )
		{
			// We have a new commit, so recompile!
			flow()
			.par( update_archive )
			.par( update_extensions )
			.seq( callback );
		}
		else
		{
			callback();
		}
	});
}

// Update archive
var update_archive = function( callback )
{
	console.log( 'Updating source code archive' );
	fs.exists( 'src/.git', function( exists )
	{
		if ( exists )
		{
			exec( 'git', [ 'pull', '-f', 'origin', 'master' ], { cwd: './src' }, callback );
		}
		else
		{
			exec( 'git', [ 'clone', '--depth', '1', 'https://github.com/i7/kerkerkruip.git', './src' ], {}, callback );
		}
	});
}

// Update other extensions
var update_extensions = function( callback )
{
	// Get the list
	request( 'https://raw.github.com/i7/kerkerkruip/master/.extensions', function( error, response, body )
	{
		var f = flow();
		var files = body.split( /\s+/ );
		for ( var i in files )
		{
			f.par( (function( i )
			{
				return function( next ) { download_extension( files[i], next ); };
			})( i ) );
		}
	});
};

var download_extension = function( url, callback )
{
	request( url, function( error, response, body )
	{
		var info = /^(?:Version \S+ of )?([\w ]+)(?: \(for Glulx only\))? by ([\w ]+) begins here/i.exec( body );
		var dest = './inform/' + info[2] + '/' + info[1] + '.i7x';
		mkdirp( path.dirname( dest ), function()
		{
			fs.writeFile( dest, body, callback );
		});
	});
};