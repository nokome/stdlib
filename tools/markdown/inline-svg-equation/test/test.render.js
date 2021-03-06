'use strict';

// MODULES //

var tape = require( 'tape' );
var render = require( './../lib/render.js' );


// FUNCTIONS //

function setup() {
	return {
		'className': 'equation',
		'align': 'center',
		'raw': 'y = mx + b',
		'label': 'eq:line'
	};
}


// TESTS //

tape( 'main export is a function', function test( t ) {
	t.equal( typeof render, 'function', 'main export is a function' );
	t.end();
});

tape( 'the function returns a string', function test( t ) {
	var str = render( setup() );
	t.equal( typeof str, 'string', 'returns a string' );
	t.end();
});

tape( 'the function returns an HTML string for rendering an inline SVG equation in Markdown', function test( t ) {
	var expected;
	var actual;

	expected = '<div class="equation" align="center" data-raw-text="y = mx + b" data-equation="eq:line">\n    <svg>beep boop</svg>\n</div>';
	actual = render( setup(), '<svg>beep boop</svg>' );

	t.equal( actual, expected, 'returns an HTML string' );
	t.end();
});
