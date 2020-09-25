#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use Data::Show;                           # Module for showing content of variables such as hashes
use Term::ANSIColor ('color', 'colored');

# Use/import our custom modules:
use lib ('lib');                          # Includes local lib-folder -> for custom modules 'Andiluca::...'
use Andiluca::Useful ("title", "assert"); # Module with various useful code snippets
use Andiluca::Understand_Data_Structure ("understand_data_structure1");
use Andiluca::Create_Empty_Random_Exam ("create_empty_random_exam");
use Andiluca::Various("parse_header", "parse_decoration_divider", "get_current_date_time_string", "read_file");
use Andiluca::Exam_Parser("parsing_exam");


my $path;

# Open given file (or standard file, if no argument is passed):
if (@ARGV == 0) {
    # die "Please provide a filepath, such as 'perl src/main.pl AssignmentDataFiles/MasterFiles/short_exam_master_file.txt'\n";

    # Use one of the standard-files:
    my $filename = "FHNW_entrance_exam_master_file_2017.txt";
    # my $file = "short_exam_master_file.txt";

    # Construct the path:
    $path = "AssignmentDataFiles/MasterFiles/" . $filename;
}
else {
    # Take first provided argument as filepath:
    $path = $ARGV[0];
}

say colored([ 'yellow' ], "This script generates an exam based on the file '$path'.");


# Open and read the whole file:
my $bare_content = read_file($path);


# Parse the various needed elements:
my $parsed_ref = parsing_exam($bare_content);
my %parsed = %{$parsed_ref};
my $header = parse_header($bare_content);
my $decoration_line = parse_decoration_divider($bare_content);


# Show the whole data structure:
# show (%parsed);

# For understanding the data-structure: just print out all the questions and their respective correct answer:
# understand_data_structure1(\%parsed);


# Create empty random exam file:
my $randomized = create_empty_random_exam(\%parsed, $header, $decoration_line);
my $date_and_time = get_current_date_time_string();

# Create the path for the output-file:
# The path is generally the same, but with an added subfolder /Generated
# And the file name gets prefixed with date and time.
# Sample input:
#     AssignmentDataFiles/MasterFiles/FHNW_entrance_exam_master_file_2017.txt
# Sample output would be:
#     AssignmentDataFiles/MasterFiles/Generated/20170904-132602-FHNW_entrance_exam_master_file_2017.txt
$path =~ s%/([^/]*)$%/Generated/$date_and_time-$1%;

# Write the file to the disk
open(my $out_fh, ">", $path) // die colored([ 'red' ], "\nUnable to open file for write-access '$path':\n\t$!\n");
say {$out_fh} $randomized;
say colored([ 'green' ], "Empty Exam-File created in '$path'.");
close($out_fh);



