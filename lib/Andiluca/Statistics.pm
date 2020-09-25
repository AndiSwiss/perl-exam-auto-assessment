package Andiluca::Statistics;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');
use Term::ANSIColor ('color', 'colored');

our @EXPORT_OK = ('generate_statistics');     # List of exported functions




sub generate_statistics($correct_answers_count_total_ref, $answered_questions_count_total_ref) {
    # Title for Statistics section:
    print color('magenta');
    my $title = "Statistics section:";
    my $title_line = "# " . "-" x length($title) . " #";
    say "\n$title_line";
    say "# $title #";
    say "$title_line\n";



    my @correct_total = @{$correct_answers_count_total_ref};
    my @answered_total = @{$answered_questions_count_total_ref};

    say "correct_total: @correct_total";
    say "answered_total: @answered_total";


    print color('reset');
}


1; # Magic true value that Perl requires for no good reason.
