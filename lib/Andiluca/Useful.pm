package Andiluca::Useful v0.0.1;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');
use Term::ANSIColor ('color', 'colored');


# ------ #
# USAGE: #
# ------ #
# For using this module, call it with the package-name Andiluca::Useful and the names of the methods to be used, e.g.:
#     use Andiluca::Useful ('assert', 'title');
# NOTE:
#  In IntelliJ, it works perfectly, if this module sits in the project root in the folder 'lib'.
#  But when trying to execute a perl-script directly from the terminal, you have to make sure that this module
#  is in one of the folders specified in the perllib-environment variable $PERL5LIB.
#  You can check the current status of this variable in your terminal with the following command:
#
#     echo $PERL5LIB
#
#  If you want to just TEMPORARILY add this module to your $PERL5LIB (as long as your terminal is open), then
#  you can simply run the following command in your console (adjust the path as needed):
#
#     export PERL5LIB="$HOME/IdeaProjects/FHNW_Perl_course_with_Damian_Conway/lib"
#
#  After this, it should work just fine!


# --------------------------- #
# List of exported functions: #
# --------------------------- #
our @EXPORT_OK = ('assert', 'title');


# ----------------------------------------------------------------- #
# Assertion for testing equality of two values (string-comparison). #
# Usage: Provide $actual, $expected and optionally a testname.      #
# ----------------------------------------------------------------- #
sub assert($actual, $expected, $testname = "unnamed") {
    state $counter = 0;
    $counter++;
    say $actual eq $expected
        ? colored([ 'green' ], "OK: Test $counter '$testname' passed: $actual")
        : colored([ 'red' ], "FAILED!!  Test $counter '$testname' failed:   actual=$actual    expected=$expected");
}


# ------------------------------ #
# Title decoration - with color: #
# ------------------------------ #
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
