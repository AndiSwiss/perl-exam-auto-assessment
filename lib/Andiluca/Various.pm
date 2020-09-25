package Andiluca::Various;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');

our @EXPORT_OK = ('parse_header', 'parse_decoration_divider');

# Parsing the whole header of the file:
sub parse_header($bare_content) {
    $bare_content =~m /([^_]*[\t\n]*)/;
    return "$1";
}

# Parsing one decoration line (divider between the questions)
sub parse_decoration_divider($bare_content) {
    $bare_content =~ m/(_+)/;
    return "$1";
}
