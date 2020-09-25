package Andiluca::Various;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');
use Term::ANSIColor ('color', 'colored');


# List of exported functions:
our @EXPORT_OK = ('parse_header', 'parse_decoration_divider', 'get_current_date_time_string', 'read_file');


# Parsing the whole header of the exam-file, using a regex:
#
# Parameters:
#   - $bare_content: Multi-line string which contains the unprocessed file-content of the exam file
# Returns:
#   - A multi-line string containing the header of the exam-file
sub parse_header($bare_content) {
    $bare_content =~ m/([^_]*[\t\n]*)/;
    return "$1";
}


# Parsing one decoration line (divider between the questions):
#
# Parameters:
#   - $bare_content: Multi-line string which contains the unprocessed file-content of the exam file
# Returns:
#   - A string containing the divider line
sub parse_decoration_divider($bare_content) {
    $bare_content =~ m/(_+)/;
    return "$1";
}


# Creates the needed current date time string:
# For help, see https://www.tutorialspoint.com/perl/perl_date_time.htm
#
# Parameters:
#   - none
# Returns:
#   - a string containing date and time in the format YYYYmmdd-hhmmss
sub get_current_date_time_string() {
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
    return(sprintf("%04d%02d%02d-%02d%02d%02d", 1900 + $year, 1 + $mon, $mday, $hour, $min, $sec));
}


# Reads the given file and returns its content:
#
# Parameters:
#   - $filepath: Path to the file
# Returns:
#   - a multi-line string containing the content of the given file
# Error Handling:
#   - Throws exception if file opening fails
sub read_file($filepath) {
    open my $fh, '<', $filepath or die colored(['red'], "Cannot read '$filepath': $!\n");
    my $bare_content = do {
        local $/;
        readline($fh)
    };
    close $fh;
    return $bare_content;
}



1; # Magic true value that Perl requires for no good reason.
