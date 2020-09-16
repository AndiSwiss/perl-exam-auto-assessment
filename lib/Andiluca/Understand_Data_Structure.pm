package Andiluca::Understand_Data_Structure;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');


our @EXPORT_OK = ('understand_data_structure1');



# Prints all questions and their respective correct answer to the terminal:
sub understand_data_structure1($parsed_reference) {
    my %parsed = %{$parsed_reference};

    # Variant 1: Direct option to read the first decoration line:
    # print $parsed{'exam'}->{'exam_component'}->[0]->{'decoration'};  # reads the first decoration line!

    # Variant 2: to read the first decoration line:
    my @arr = @{$parsed{'exam'}->{'exam_component'}}; # Array containing references to the hashes!
    # print $arr[0]->{'decoration'};

    # Variant 3: - with more de-referencing:
    # my %hash1 = %{$arr[0]};
    # print $hash1{'decoration'};


    # ----------------------------------- #
    # Save all questions in a hash-array: #
    # ----------------------------------- #

    #  DATA-STRUCTURE for 'question_and_answers':
    #      {
    #       exam => {
    #         exam_component => [
    #           {
    #             question_and_answers => {
    #               answer   => [
    #                             { checkbox => "[X]", text => " List, scalar, and void\n" },
    #                             { checkbox => "[ ]", text => " List, linear, and void\n" },
    #                             { checkbox => "[ ]", text => " List, scalar, and null\n" },
    #                             { checkbox => "[ ]", text => " Null, scalar, and void\n" },
    #                             { checkbox => "[ ]", text => " Blood, sweat, and tears\n" },
    #                           ],
    #               question => {
    #                             question_number => "2.",
    #                             text => " Perl's three main types of call context (or \"amount context\") are:\n",
    #                           },
    #             },
    #           },
    #
    #
    my @all_questions;
    for my $ref (@arr) {
        my %entry = %{$ref};
        if (exists($entry{"question_and_answers"})) {
            push(@all_questions, $entry{"question_and_answers"});
        }
    }

    # Variant 1: Getting one question:
    # print $all_questions[0]->{"question"}->{"text"};

    # Variant 2:
    my %q0 = %{$all_questions[0]};
    # print $q0{"question"}->{"text"};


    # Getting all questions and their corresponding correct answer:
    for my $q_ref (@all_questions) {
        my %q = %{$q_ref};

        print "QUESTION " . $q{"question"}->{"question_number"} . ": " . $q{"question"}->{"text"};

        # Getting the CORRECT answer:
        my $correct_answer;
        for my $answer (@{$q{'answer'}}) {
            if ($answer->{'checkbox'} eq "[X]") {
                $correct_answer = $answer->{text};
            }
        }
        say " -> CORRECT ANSWER:  $correct_answer";
    }
}






1; # Magic true value that Perl requires for no good reason.
