'use strict';

// MODULES //

var debug = require( 'debug' )( 'lint:pkg-json:sync' );
var glob = require( 'glob' ).sync;
var resolve = require( 'path' ).resolve;
var cwd = require( '@stdlib/utils/cwd' );
var copy = require( '@stdlib/utils/copy' );
var readJSON = require( '@stdlib/fs/read-json' ).sync;
var isValid = require( './../../../pkg-json/validate' );
var config = require( './config.json' );
var validate = require( './validate.js' );


// MAIN //

/**
* Synchronously lint `package.json` files.
*
* @param {Options} [options] - function options
* @param {string} [options.dir] - root directory from which to search for packages
* @param {string} [options.pattern='**\/package.json'] - glob pattern
* @param {StringArray} [options.ignore] - glob pattern(s) to exclude matches
* @throws {TypeError} options argument must be an object
* @throws {TypeError} must provide valid options
* @throws {Error} `pattern` option must end with `package.json`
* @returns {(ObjectArray|null)} lint errors or `null`
*
* @example
* var errs = lint();
* if ( errs ) {
*     console.dir( errs );
* } else {
*     console.log( 'Success!' );
* }
*/
function lint( options ) {
	var files;
	var gopts;
	var total;
	var file;
	var opts;
	var bool;
	var err;
	var dir;
	var out;
	var i;
	var j;

	opts = copy( config );
	if ( arguments.length ) {
		err = validate( opts, options );
		if ( err ) {
			throw err;
		}
	}
	if ( opts.dir ) {
		dir = resolve( cwd(), opts.dir );
	} else {
		dir = cwd();
	}
	gopts = {
		'cwd': dir,
		'ignore': opts.ignore,
		'realpath': true // return absolute file paths
	};
	debug( 'Glob options: %s', JSON.stringify( gopts ) );

	debug( 'Searching for `package.json` files.' );
	files = glob( opts.pattern, gopts );

	total = files.length;
	debug( 'Found %d files.', total );
	if ( total === 0 ) {
		return null;
	}
	debug( 'Processing files.' );
	out = [];
	for ( i = 0; i < total; i++ ) {
		j = i + 1;
		debug( 'Reading file: %s (%d of %d).', files[ i ], j, total );
		file = readJSON( files[ i ] );
		if ( file instanceof Error ) {
			debug( 'Encountered an error reading file: %s (%d of %d). Error: %s', files[ i ], j, total, file.message );
			out.push({
				'file': files[ i ],
				'errors': [
					{
						'message': file.message
					}
				]
			});
		} else {
			debug( 'Successfully read file: %s (%d of %d).', files[ i ], j, total );
			debug( 'Linting file.' );
			bool = isValid( file );
			if ( bool ) {
				debug( 'File is valid.' );
			} else {
				debug( 'File is invalid: %s.', JSON.stringify( isValid.errors ) );
				out.push({
					'file': files[ i ],
					'errors': isValid.errors
				});
			}
		}
		debug( 'Processed %d of %d files.', j, total );
	}
	debug( 'Processed all files.' );
	if ( out.length ) {
		return out;
	}
	return null;
} // end FUNCTION lint()


// EXPORTS //

module.exports = lint;
