package Andiluca::Create_Empty_Random_Exam;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');
use Data::Show;                           # Module for showing content of variables such as hashes
use List::Util ('shuffle');


our @EXPORT_OK = ('create_empty_random_exam');



sub create_empty_random_exam($parsed_reference, $header, $decoration_line) {
    my %parsed = %{$parsed_reference};

    my @arr = @{$parsed{'exam'}->{'exam_component'}}; # Array containing references to the hashes!


    my $file_content;

    # Add header of the file:
    $file_content = $header;
    $file_content .= "$decoration_line\n\n";

    # For checking success of the following operation:
    my $amount_of_parsed_questions = 0;


    for my $ref (@arr) {
        my %entry = %{$ref};
        if (exists($entry{"question_and_answers"})) {
            $amount_of_parsed_questions++;
            my %question = %{$entry{"question_and_answers"}->{"question"}};
            $file_content .= $question{"question_number"} . " " . $question{"text"} . "\n";
            # push(@all_questions, $entry{"question_and_answers"});

            my @answers = @{$entry{"question_and_answers"}->{"answer"}};

            # Randomize the questions (with shuffle) and iterate over them:
            for my $answer (shuffle@answers){
                $file_content .= "    [ ] " . $answer->{'text'};
            }


            $file_content .= "\n$decoration_line\n\n";
        }
    }

    if ($amount_of_parsed_questions > 0) {
        return $file_content;
    } else {
        return undef;
    }
}


1; # Magic true value that Perl requires for no good reason.
