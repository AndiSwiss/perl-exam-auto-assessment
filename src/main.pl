#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use Regexp::Grammars;                     # Module for using Grammars in Regex
use Data::Show;                           # Module for showing content of variables such as hashes
use Term::ANSIColor ('color', 'colored');

# Use/import our custom modules:
use lib ('lib');                          # Includes local lib-folder -> for custom modules 'Andiluca::...'
use Andiluca::Useful ("title", "assert"); # Module with various useful code snippets
use Andiluca::Understand_Data_Structure ("understand_data_structure1");
use Andiluca::Create_Empty_Random_Exam ("create_empty_random_exam");
use Andiluca::Various("parse_header", "parse_decoration_divider", "get_current_date_time_string");


my $path;

# Open given file (or standard file):
if (@ARGV == 0) {
    # die "Please provide a filepath, such as 'perl src/main.pl AssignmentDataFiles/MasterFiles/short_exam_master_file.txt'\n";

    # Use one of the standard-files:
    my $filename = "FHNW_entrance_exam_master_file_2017.txt";
    # my $file = "short_exam_master_file.txt";

    # Construct the path:
    $path = "AssignmentDataFiles/MasterFiles/" . $filename;

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

my $header = parse_header($bare_content);
my $decoration_line = parse_decoration_divider($bare_content);



# Run the regex-grammar to create the hash-object:
if ($bare_content =~ $exam_parser) {
    %parsed = %/; # '%/' is a special variable from the Regexp-module to fetch the created data-structure

    # Show the whole data structure:
    # show (%parsed);

    # For understanding the data-structure: just print out all the questions and their respective correct answer:
    # understand_data_structure1(\%parsed);

    # Create empty random exam file:
    my $randomized = create_empty_random_exam(\%parsed, $header, $decoration_line);
    if (!defined $randomized) {
        warn colored([ 'red' ], 'Method "create_empty_random_exam(\%parsed)" failed!!');
    } else {
        # TODO: write the file to disk

        my $date_and_time = get_current_date_time_string();

        # Create the path for the output-file:
        # The path is generally the same, but with an added subfolder /Generated
        # And the file name gets prefixed with date and time.
        # Sample input:
        #     AssignmentDataFiles/MasterFiles/FHNW_entrance_exam_master_file_2017.txt
        # Sample output would be:
        #     AssignmentDataFiles/MasterFiles/Generated/20170904-132602-FHNW_entrance_exam_master_file_2017.txt
        $path =~ s%/([^/]*)$%/Generated/$date_and_time-$1%;

        open(my $out_fh, ">", $path) // die colored([ 'red' ], "\nUnable to open file for write-access '$path':\n\t$!\n");
        say {$out_fh} $randomized;
        say "Empty Exam-File created in '$path'";
        close($out_fh);
    }


}
else {
    warn 'Not a valid exam file';
}


