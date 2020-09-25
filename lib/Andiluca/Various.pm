package Andiluca::Various;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');

our @EXPORT_OK = ('parse_header', 'parse_decoration_divider', 'get_current_date_time_string');

# Parsing the whole header of the file:
sub parse_header($bare_content) {
    $bare_content =~ m/([^_]*[\t\n]*)/;
    return "$1";
}

# Parsing one decoration line (divider between the questions)
sub parse_decoration_divider($bare_content) {
    $bare_content =~ m/(_+)/;
    return "$1";
}

# Creates the needed current date time string
# For help, see https://www.tutorialspoint.com/perl/perl_date_time.htm
sub get_current_date_time_string() {
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
    return(sprintf("%04d%02d%02d-%02d%02d%02d", 1900 + $year, 1 + $mon, $mday, $hour, $min, $sec));
}


1; # Magic true value that Perl requires for no good reason.
