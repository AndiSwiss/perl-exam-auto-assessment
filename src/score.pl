#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Data::Show;                           # Module for showing content of variables such as hashes
use POSIX;
use Lingua::StopWords qw( getStopWords );
use Text::Levenshtein::Damerau qw/edistance/;
use Term::ANSIColor ('color', 'colored');

# Use/import our custom modules:
use lib ('lib');                          # Includes local lib-folder -> for custom modules 'Andiluca::...'
use Andiluca::Useful ("title", "assert"); # Module with various useful code snippets
use Andiluca::Understand_Data_Structure ("understand_data_structure1");
use Andiluca::Create_Empty_Random_Exam ("create_empty_random_exam");
use Andiluca::Exam_Parser("parsing_exam");
use Andiluca::Various('read_file');


my $master_path;
my @student_file_paths;

# Open given file (or standard file):
if (@ARGV < 2) {
    # die "Please provide a filepath, such as 'perl src/main.pl AssignmentDataFiles/MasterFiles/short_exam_master_file.txt'\n";

    # Use standard-file:
    my $file = "FHNW_entrance_exam_master_file_2017.txt";
    $master_path = "AssignmentDataFiles/MasterFiles/" . $file;

    $student_file_paths[0] = "AssignmentDataFiles/SampleResponses/20170828-092520-FHNW_entrance_exam-ID00001010"
}
else {
    # Take provided filepath:
    $master_path = $ARGV[0];
    # say("All student exams: ");
    for my $sf (@ARGV[1..((scalar @ARGV) -1)]){
        push @student_file_paths, $sf;
        # say $sf;
    }
    # say "\n";
    # say join(", ", @student_file_paths);
}


# Reads file and returns bare content
my $bare_content = read_file($master_path);
my %parsed_master_hash = %{parsing_exam($bare_content)};
my @parsed_master = get_questions_and_answers(@{$parsed_master_hash{'exam'}->{'exam_component'}});


# Receive all questions and answers:
sub get_questions_and_answers(@parsed){
    my @all_questions;
    for my $ref (@parsed) {
        my %entry = %{$ref};
        if (exists($entry{"question_and_answers"})) {
            push(@all_questions, $entry{"question_and_answers"});
        }
    }
    return @all_questions;
}

# Normalizes String according by removing and simplifying whitespaces, lowercasing and removing stop words
sub normalize($string){
    my $stopwords = getStopWords('en');

    $string = lc $string;
    # Removes multiple whitespaces and stopwords
    $string = join ' ', grep { !$stopwords->{$_} } split /\s+/, $string;
    $string =~ s/^\s+|\s+$//g; #remove leading and trailing whitespaces

    return $string;
}

# Compares 2 normalized strings and returns their edit distance;
sub compare($s1, $s2){
    $s1 = normalize($s1);
    $s2 = normalize($s2);
    # say $s1 . " vs. " . $s2;
    my $maxDist = floor(length( $s2) * 0.1);
    return $maxDist ? edistance($s1, $s2, $maxDist) : ($s1 eq $s2 ? 0 : -1);
}


# Compare and score the student exam with the master file
sub score_exam($sf, @parsed_exam) {
    my $answered_questions_count = 0;
    my $correct_answers_count = 0;

    # Index Offset used when a Question is missing in the middle of the Exam
    my $master_offset = 0;
    
    say colored(['yellow'], $sf . ":");

    # Loop through masterfile
    foreach my $i (0..((scalar @parsed_master)-1)){

        if(!exists($parsed_master[$i + $master_offset])){next;}
        my %qa_master = %{$parsed_master[$i + $master_offset]};


        # Check for missing Question at the end of the file
        if(!exists($parsed_exam[$i])){ 
            say "\t" . "Missing Question " . @{$qa_master{"question"}}{"question_number"} . "\n\t " . @{$qa_master{"question"}}{"text"};
            next;
        }

        my %qa_student = %{$parsed_exam[$i]};

        # Find and set correct answer and check for missing Answers
        my $correct_answer = "";
        for my $answer (@{$qa_master{"answer"}}){
            if($answer->{"checkbox"} eq "[X]"){
                $correct_answer = $answer->{"text"};
            }

            # Check for missing Answers
            my $contains = 0;
            for my $answer_student (@{$qa_student{'answer'}}) {
                my $cmp = compare($answer_student->{"text"}, $answer->{"text"});
                if($cmp >= 0 ){
                    $contains = 1;
                    if($cmp > 0){
                        say 'Inexact Match [Answer], used: "' . $answer->{"text"} . '" instead of "' . $answer_student->{"text"} . '"';
                    }
                    last;
                }
            }
            if($contains == 0){
                say "\t" . "Missing answer in question " . @{$qa_master{"question"}}{"question_number"} . ":\n\t " . $answer->{"text"}; 
            }
        }

        # Check for missing Questions inside the Exam (not at the end)
        # Not matching question number -> missing question
        while(compare(@{$qa_master{"question"}}{"question_number"}, @{$qa_student{"question"}}{"question_number"}) == -1){
            say "\t" . "Missing Question " . @{$qa_master{"question"}}{"question_number"} . "\n\t " . @{$qa_master{"question"}}{"text"};
            
            # Increase offset for next iteration
            $master_offset++;
            
            # Reassign Current master QA and Correct Answer
            %qa_master = %{$parsed_master[$i + $master_offset]};
            # Find and set correct answer 
            for my $answer (@{$qa_master{"answer"}}){
                if($answer->{"checkbox"} eq "[X]"){
                    $correct_answer = $answer->{"text"};
                }
            }
        }
        
        # Score Answers
        my $count = 0; #Count of X's
        for my $answer (@{$qa_student{'answer'}}) {
            if ($answer->{'checkbox'} =~ /\[\s*[xX]\s*\]/) { # Match all types of X's with Spaces before and after
                $count++;
                my $correct = 0; #Correct Answer selected?
                
                # If only 1 X, increase answered question count
                if($count == 1) {$answered_questions_count++;}
            
                # If only 1 X and correct answer
                my $cmp = compare($answer->{"text"}, $correct_answer);
                if($count == 1 && $cmp >= 0){
                    $correct_answers_count++;
                    $correct = 1;
                    if($cmp > 0){
                        say 'Inexact Match [Answer], used: "' . $correct_answer . '" instead of "' . $answer->{"text"} . '"';
                    }
                }

                # Adjust count if more than 1 Answer selected
                elsif($correct == 1 && $count > 1){
                    $correct_answers_count--;
                    $correct = 0;
                }
            }
        }
    }

    # Print the results to the terminal:
    say "Score: \t" . $correct_answers_count . "/" . $answered_questions_count . "\n";
}




# Compare Student File with Master file
# Loop through every Student File
for my $sf (@student_file_paths){
    my %parsed_exam_hash = %{parsing_exam(read_file($sf))};
    my @parsed_exam = get_questions_and_answers(@{$parsed_exam_hash{'exam'}->{'exam_component'}});


    score_exam($sf, @parsed_exam);


    # TODO TEST
    # say compare("1.042e3", "1'042");

}




