/*

Kerkerkruip build server utilities
==================================

Copyright (c) 2013 Dannii Willis
BSD licenced
https://github.com/i7/kerkerkruip

*/

var exec = require( 'child_process' ).execFile;
var fs = require( 'fs' );
var mkdirp = require( 'mkdirp' );
var path = require( 'path' );

var DATA_FILE = './data.json';

// A simple data store
if ( !fs.existsSync( DATA_FILE ) )
{
	fs.writeFileSync( DATA_FILE, JSON.stringify( {
		last: 'Unknown',
		laststable: 'Unknown',
	} ) );
}

var _data = require( DATA_FILE );

var data = exports.data = function( key, value )
{
	if ( arguments.length == 2 )
	{
		_data[key] = value;
		fs.writeFile( DATA_FILE, JSON.stringify( _data ), function(){} );
		return;
	}
	return _data[key];
};

// Download a file
var downloadtofile = exports.downloadtofile = function( url, dest, callback )
{
	mkdirp( path.dirname( dest ), function()
	{
		// Use gzip, follow redirects
		exec( 'curl', [ '--compressed', '-L', '-o', dest, url ], {}, callback );
	});
};

// Unzip a zip
var unzip = exports.unzip = function( file, dest, callback )
{
	exec( 'tar', [ '-x', '-z', '-f', file, '-C', dest ], {}, callback );
};