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
var request = require( 'request' );

var util = require( './util.js' );

// Use the API to get the latest commit
exports.update = function( callback )
{
	request( {
		url: 'https://api.github.com/repos/i7/kerkerkruip/commits',
		headers: { 'User-Agent': 'Kerkerkruip/1.0' },
	}, function( error, response, body )
	{
		var json = JSON.parse( body );
		var oldlast = util.data( 'last' );
		var last = json[0].sha.substr( 0, 7 );
		util.data( 'last', last );
		
		if ( oldlast != last )
		{
			update_archive( callback );
		}
		else
		{
			callback();
		}
	});
}

// Update archive
function update_archive( callback )
{
	console.log( 'Updating source code archive' );
	fs.exists( 'src/README.md', function( exists )
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