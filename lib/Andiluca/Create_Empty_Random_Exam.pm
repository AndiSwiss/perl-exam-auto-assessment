package Andiluca::Create_Empty_Random_Exam;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');
use Data::Show;                           # Module for showing content of variables such as hashes
use List::Util ('shuffle');
use Term::ANSIColor ('color', 'colored');


our @EXPORT_OK = ('create_empty_random_exam');   # List of exported functions


# Create an empty exam ready for a student to be filled out.
# The returned string will contain randomized answers for each question.
# All the [X] marks (for correct answers) will not be shown.
#
# Parameters:
#   - $parsed_ref: Remember to pass the nested hash-object %parsed by reference: \%parsed
#   - $header: The multiline string containing the header of the exam file
#   - $decoration_line
# Returns:
#   - The created multiline-string will be returned.
# Error Handling:
#   - Throws exception If no questions/answers could be reconstructed
sub create_empty_random_exam($parsed_ref, $header, $decoration_line) {
    # Dereference the parsed object
    my %parsed = %{$parsed_ref};

    # Array containing references to the hashes:
    my @arr = @{$parsed{'exam'}->{'exam_component'}};

    # Variable which will contain the actual result:
    my $file_content;

    # Add header of the file:
    $file_content = $header;
    $file_content .= "$decoration_line\n\n";

    # For checking success of the following operation:
    my $amount_of_parsed_questions = 0;

    # Recreate the questions and randomized ordered answers
    for my $ref (@arr) {
        my %entry = %{$ref};

        # Only process the elements, which are 'question_and_answers':
        if (exists($entry{"question_and_answers"})) {
            $amount_of_parsed_questions++;
            my %question = %{$entry{"question_and_answers"}->{"question"}};
            $file_content .= $question{"question_number"} . " " . $question{"text"} . "\n";

            my @answers = @{$entry{"question_and_answers"}->{"answer"}};

            # Randomize the questions (with shuffle from List::Util) and iterate over them:
            for my $answer (shuffle@answers){
                $file_content .= "    [ ] " . $answer->{'text'};
            }

            # Add the horizontal divider lines
            $file_content .= "\n$decoration_line\n\n";
        }
    }

    # Check if questions could be read and processed successfully:
    if ($amount_of_parsed_questions > 0) {
        return $file_content;
    } else {
        die colored([ 'red' ], 'Method "create_empty_random_exam(\%parsed)" failed!!');
    }
}


1; # Magic true value that Perl requires for no good reason.
