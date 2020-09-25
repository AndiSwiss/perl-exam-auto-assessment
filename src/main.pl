#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Data::Show;                           # Module for showing content of variables such as hashes
use Term::ANSIColor ('color', 'colored');

# Use/import our custom modules:
use lib ('lib');                          # Includes local lib-folder -> for custom modules 'Andiluca::...'
use Andiluca::Useful ("title", "assert"); # Module with various useful code snippets
use Andiluca::Understand_Data_Structure ("understand_data_structure1");
use Andiluca::Create_Empty_Random_Exam ("create_empty_random_exam");
use Andiluca::Various("parse_header", "parse_decoration_divider", "get_current_date_time_string", "read_file");
use Andiluca::Exam_Parser("parsing_exam");


my @files;

# If the user doesn't provide an argument, all the *.txt in the folder 'AssignmentDataFiles/MasterFiles/' are used:
if (@ARGV == 0) {
    @files = glob("AssignmentDataFiles/MasterFiles/*.txt");
}
# Otherwise, a user can provide one or multiple file-paths to specific master-files:
else {
    for my $file (@ARGV){
        push (@files, $file);
    }
}

for my $file (@files) {
    generate_exam($file);
}



sub generate_exam($file_path) {
    say colored([ 'yellow' ], "Generating exam based on the file '$file_path':");

    # Open and read the whole file:
    my $bare_content = read_file($file_path);


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

    # Create subdirectory /Generated, if not yet present:
    $file_path =~ m%(.*(.*/)*/)[^/]*$%;
    my $path_generated = $1 . "/Generated";
    if (!-d $path_generated) {
        mkdir ($path_generated);
    }

    # Create the path for the output-file:
    # The path is generally the same, but with an added subfolder /Generated
    # And the file name gets prefixed with date and time.
    # Sample input:
    #     AssignmentDataFiles/MasterFiles/FHNW_entrance_exam_master_file_2017.txt
    # Sample output would be:
    #     AssignmentDataFiles/MasterFiles/Generated/20170904-132602-FHNW_entrance_exam_master_file_2017.txt
    $file_path =~ s%/([^/]*)$%/Generated/$date_and_time-$1%;


    # Write the file to the disk
    open(my $out_fh, ">", $file_path) // die colored([ 'red' ], "\nUnable to open file for write-access '$file_path':\n\t$!\n");
    say {$out_fh} $randomized;
    say colored([ 'green' ], "       Empty Exam-File created in '$file_path'.");
    close($out_fh);
}
