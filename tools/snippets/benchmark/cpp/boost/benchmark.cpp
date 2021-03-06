/**
* Benchmark Boost `TODO`.
*/
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <sys/time.h>
#include <boost/random/mersenne_twister.hpp>
#include <boost/random/uniform_real_distribution.hpp>
#include <boost/TODO/TODO.hpp>

using boost::random::uniform_real_distribution;
using boost::random::mt19937;

#define NAME "TODO"
#define ITERATIONS 1000000
#define REPEATS 3

/**
* Prints the TAP version.
*/
void print_version() {
	printf( "TAP version 13\n" );
}

/**
* Prints the TAP summary.
*
* @param total     total number of tests
* @param passing   total number of passing tests
*/
void print_summary( int total, int passing ) {
	printf( "#\n" );
	printf( "1..%d\n", total ); // TAP plan
	printf( "# total %d\n", total );
	printf( "# pass  %d\n", passing );
	printf( "#\n" );
	printf( "# ok\n" );
}

/**
* Prints benchmarks results.
*
* @param elapsed   elapsed time in seconds
*/
void print_results( double elapsed ) {
	double rate = (double)ITERATIONS / elapsed;
	printf( "  ---\n" );
	printf( "  iterations: %d\n", ITERATIONS );
	printf( "  elapsed: %0.9f\n", elapsed );
	printf( "  rate: %0.9f\n", rate );
	printf( "  ...\n" );
}

/**
* Returns a clock time.
*
* @return clock time
*/
double tic() {
	struct timeval now;
	gettimeofday( &now, NULL );
	return (double)now.tv_sec + (double)now.tv_usec/1.0e6;
}

/**
* Runs a benchmark.
*
* @return elapsed time in seconds
*/
double benchmark() {
	double elapsed;
	double x;
	double y;
	double t;
	int i;

	// Define a new pseudorandom number generator:
	mt19937 rng;

	// Define a uniform distribution for generating pseudorandom numbers as "doubles" between a minimum value (inclusive) and a maximum value (exclusive):
	uniform_real_distribution<> randu( 0.0, 1.0 );

	t = tic();
	for ( i = 0; i < ITERATIONS; i++ ) {
		x = randu( rng );
		y = 0.0; // TODO
		if ( y != y ) {
			printf( "should not return NaN\n" );
			break;
		}
	}
	elapsed = tic() - t;
	if ( y != y ) {
		printf( "should not return NaN\n" );
	}
	return elapsed;
}

/**
* Main execution sequence.
*/
int main( void ) {
	double elapsed;
	int i;

	print_version();
	for ( i = 0; i < REPEATS; i++ ) {
		printf( "# cpp::boost::%s\n", NAME );
		elapsed = benchmark();
		print_results( elapsed );
		printf( "ok %d benchmark finished\n", i+1 );
	}
	print_summary( REPEATS, REPEATS );
	return 0;
}
