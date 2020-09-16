#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use lib ('lib');                          # Includes local lib-folder -> for custom modules 'Andiluca::...'
use Andiluca::Useful ("title", "assert"); # Module with various useful code snippets
use Regexp::Grammars;                     # Module for using Grammars in Regex
use Data::Show;                           # Module for showing content of variables such as hashes
# use File::Path;    # TODO:  maybe implement this for consistent behaviour on windows?


my $path;

# Open given file (or standard file):
if (@ARGV == 0) {
    # die "Please provide a filepath, such as 'perl src/main.pl AssignmentDataFiles/MasterFiles/short_exam_master_file.txt'\n";

    # Use standard-file:
    my $file = "FHNW_entrance_exam_master_file_2017.txt";
    $path = "AssignmentDataFiles/MasterFiles/" . $file;
}
else {
    # Take provided filepath:
    $path = $ARGV[0];
}


# Open and read the whole file:
open my $fh, '<', $path or die "Cannot read '$path': $!\n";
my $bare_content = do {
    local $/;
    readline($fh)
};
close $fh;


# Define the regex grammar (using the module Regexp::Grammars):
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
        \d+ \.

    <token: text>
        \N* \n                  # First line of text may be anything
        (?: \N* \S \N* \n )*?   # Extra lines of text must contain a non-space
                                # The ? at the end modifies the * (0 or more) to "use the one with the least amount ???

    <token: checkbox>
        \[ . \]

    <token: decoration>
        \N* \n

    <token: empty_line>
        \s* \n
}xms;

my %parsed;

# Run the regex-grammar to create the hash-object:
if ($bare_content =~ $exam_parser) {
    %parsed = %/; # '%/' is a special variable from the Regexp-module to fetch the created data-structure

    # Show the whole data structure:
    # show (%parsed);

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
else {
    warn 'Not a valid exam file';
}


