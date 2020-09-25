package Andiluca::Useful v0.0.1;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');
use Term::ANSIColor ('color', 'colored');

our @EXPORT_OK = ('assert', 'title');     # List of exported functions



# Assertion for testing equality of two values (string-comparison).
# The tests will have a colored output:
#   - red: fail
#   - green: pass
# And the tests will be automatically numbered.
#
# Parameters:
#   - $actual: actual result
#   - $expected: expected result
#   - $testname: (optional parameter, default: 'unnamed')
# Returns:
#   - Nothing
sub assert($actual, $expected, $testname = "unnamed") {
    state $counter = 0;
    $counter++;
    say $actual eq $expected
        ? colored([ 'green' ], "OK: Test $counter '$testname' passed: $actual")
        : colored([ 'red' ], "FAILED!!  Test $counter '$testname' failed:   actual=$actual    expected=$expected");
}



# Title decoration - with color:
#
# Parameters:
#   - $actual: actual result
#   - $expected: expected result
#   - $testname: (optional parameter, default: 'unnamed')
# Returns:
#   - Nothing
sub title($title) {
    # Add a ':' at the end of the string if not already present:
    # $title .= ':' if (substr($title, -1) ne ':');     # Variation 1
    # $title .= ':' if !($title =~ /:$/);               # Variation 2, with regex
    # $title =~ s/([^:])$/$1:/;                # Variation 3 - by Damian Conway (match a character which is not present)
    $title =~ s/(?<!:)$/:/;                    # Variation 4 - by Damian Conway (using negative lookbehind)
    # Hint: try these regexes on https://regex101.com/ (or similar) for interactive explanation.

    # Actual printing:
    print color('bold yellow');
    say "\n$title";
    say "-" x length($title);
    print color('reset');
}



1; # Magic true value that Perl requires for no good reason.
