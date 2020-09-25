package Andiluca::Statistics;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');
use Term::ANSIColor ('color', 'colored');

our @EXPORT_OK = ('print_statistics');     # List of exported functions


# Print various statistics:
sub print_statistics($correct_answers_count_total_ref, $answered_questions_count_total_ref) {
    # Title for Statistics section:
    print color('magenta');
    say uc "\n\nStatistics section:";
    say "-" x 46;

    # Dereference the arrays:
    my @correct_total = @{$correct_answers_count_total_ref};
    my @answered_total = @{$answered_questions_count_total_ref};

    # Sort the arrays:
    @correct_total = sort { $a <=> $b } @correct_total;
    @answered_total = sort {$a <=> $b } @answered_total;

    # Generate sum with short-hand for-loop:
    my ($sum_correct, $sum_answered) = (0, 0);
    $sum_correct += $_ for @correct_total;
    $sum_answered += $_ for @answered_total;

    # Print the statistics values
    one_line("Number of analysed tests.................", scalar(@correct_total));
    say "";
    one_line("Average number of correct answers........", $sum_correct / @correct_total);
    one_line("Minimum.....", $correct_total[0]);
    one_line("Maximum.....", $correct_total[-1]);
    say "";
    one_line("Average number of questions answered.....", $sum_answered / @answered_total);
    one_line("Minimum.....", $answered_total[0]);
    one_line("Maximum.....", $answered_total[-1]);

    # Reset the terminal-color:
    say "-" x 46 . "\n";
    print color('reset');
}


sub one_line($text, $value) {
    printf("%41s %4d\n", $text, $value);
}

1; # Magic true value that Perl requires for no good reason.
