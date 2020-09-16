package Andiluca::Create_Empty_Random_Exam;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');


our @EXPORT_OK = ('create_empty_random_exam');



sub create_empty_random_exam($parsed_reference) {
    my %parsed = %{$parsed_reference};

    # TODO: create the empty random exam file from the parsed data




    # TODO: return whether the operation was successful or not:
    return undef;
}


1; # Magic true value that Perl requires for no good reason.
