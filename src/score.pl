#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Data::Show;                           # Module for showing content of variables such as hashes
use Regexp::Grammars;                     # Module for using Grammars in Regex

# Use/import our custom modules:
use lib ('lib');                          # Includes local lib-folder -> for custom modules 'Andiluca::...'
use Andiluca::Useful ("title", "assert"); # Module with various useful code snippets
use Andiluca::Understand_Data_Structure ("understand_data_structure1");
use Andiluca::Create_Empty_Random_Exam ("create_empty_random_exam");


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
sub read_file($filepath) {
    open my $fh, '<', $filepath or die "Cannot read '$filepath': $!\n";
    my $bare_content = do {
        local $/;
        readline($fh)
    };
    close $fh;

    return $bare_content;
}

my $exam_parser = qr{

        # <debug: on>           # Uncomment this to turn on the debugger, where you can step through

        <exam>

        <nocontext:>            # With this, the data structure only contains what it found in the sub-components.
                                # If you uncomment this, then you also get all the unnamed elements which are matched.

        <rule: exam>
            <[exam_component]>*         # Meaning, look for exam_components  (0 or more)

        <rule: exam_component>
            <question_and_answers> | <decoration>   # A component contains Questions&Answers or Decoration

        <rule: question_and_answers>    # This will be like a hash, containing a question and one or more answers
            <question>
            <[answer]>+
            <.empty_line>               # The dot just says: it has to be here, but it won't be saved in this group

        <token: question>               # 'token': now, I want to actually match stuff
            \s* <question_number> <text>

        <token: answer>
            \s* <checkbox> <text>

        <token: question_number>
            \s*\d+ \.

        <token: text>
            \N* \n                  # First line of text may be anything
            (?: \N* \S \N* \n )*?   # Extra lines of text must contain a non-space
                                    # The ? at the end modifies the * (0 or more) to "use the one with the least amount ???

        <token: checkbox>
            \[ \s*[^\]]*\s* \]

        <token: decoration>
            \N* \n

        <token: empty_line>
            \s* \n
    }xms;



my %parsed_master_hash =  get_parsed_exam(read_file($master_path));
my @parsed_master = get_questions_and_answers(@{$parsed_master_hash{'exam'}->{'exam_component'}});


# Returns parsed exam, takes bare_contents
sub get_parsed_exam ($content){ 
    my %parsed;

    # Run the regex-grammar to create the hash-object:
    if ($content =~ $exam_parser) {
        %parsed = %/; # '%/' is a special variable from the Regexp-module to fetch the created data-structure
        
        # Show the whole data structure:
        # show (%parsed);

        # my @arr = @{$parsed{'exam'}->{'exam_component'}}; # Array containing references to the hashes!
        return %parsed;
    }   
    else {
        warn 'Not a valid exam file';
        return 0;
    }
}

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

# Compare and score the student exam with the master file
sub score_exam($sf, @parsed_exam) {
    my $answered_questions_count = 0;
    my $correct_answers_count = 0;

    # Index Offset used when a Question is missing in the middle of the Exam
    my $master_offset = 0;
    
    say $sf . ":";

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
                if($answer_student->{"text"} eq $answer->{"text"}){
                    $contains = 1;
                    last;
                }
            }
            if($contains == 0){
                say "\t" . "Missing answer in question " . @{$qa_master{"question"}}{"question_number"} . ":\n\t " . $answer->{"text"}; 
            }
        }

        # Check for missing Questions inside the Exam (not at the end)
        # Not matching question number -> missing question
        while(@{$qa_master{"question"}}{"question_number"} ne @{$qa_student{"question"}}{"question_number"}){
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
                if($count == 1 && $answer->{"text"} eq $correct_answer){
                    $correct_answers_count++;
                    $correct = 1;
                }

                # Adjust count if more than 1 Answer selected
                elsif($correct == 1 && $count > 1){
                    $correct_answers_count--;
                    $correct = 0;
                }
            }
        }
    }

    say "Score: \t" . $correct_answers_count . "/" . $answered_questions_count . "\n";

}




# Compare Student File with Master file
# Loop through every Student File
for my $sf (@student_file_paths){
    my %parsed_exam_hash = get_parsed_exam(read_file($sf));
    my @parsed_exam = get_questions_and_answers(@{$parsed_exam_hash{'exam'}->{'exam_component'}});


    score_exam($sf, @parsed_exam);
}




