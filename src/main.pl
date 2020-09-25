#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Data::Show;                           # Module for showing content of variables such as hashes
use Term::ANSIColor ('color', 'colored');

# Use/import our custom modules:
use lib ('lib');                          # Includes local lib-folder -> for custom modules 'Andiluca::...'
use Andiluca::Understand_Data_Structure ('understand_data_structure1');
use Andiluca::Create_Empty_Random_Exam ('create_empty_random_exam');
use Andiluca::Various('parse_header', 'parse_decoration_divider', 'read_file', 'save_file', 'create_new_file_path');
use Andiluca::Exam_Parser('parsing_exam');


# ------------------------------------------ #
# Main script for creating empty exam files  #
# with randomized answers for each question. #
# ------------------------------------------ #

# File-array containing all the file-paths of the given exam-files:
my @files;

# If the user doesn't provide an argument, all the *.txt in the folder 'AssignmentDataFiles/MasterFiles/' are used:
if (@ARGV == 0) {
    @files = glob("AssignmentDataFiles/MasterFiles/*.txt");
}
# Otherwise, a user can provide one or multiple file-paths to specific master-files:
# File-globbing works as expected, e.g.:  ../my_subfolder/*.txt
else {
    for my $file (@ARGV){
        push (@files, $file);
    }
}

# For each file, parse and generate the new empty exam file:
for my $file (@files) {
    generate_exam($file);
}



# -------------------- #
# VARIOUS SUB-ROUTINES #
# -------------------- #

# Reads the provided file, parses it and generates a new empty exam file with randomized answers:
#
# Parameters:
#   - $filepath: Path to the file
# Returns:
#   - nothing
# Error Handling:
#   - The called subroutines may throw exceptions (as described in the header of each called subroutine)
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


    # Construct the file-path for the new file:
    my $out_path = create_new_file_path($file_path);


    # Write the file to the disk:
    save_file($randomized, $out_path);
}
