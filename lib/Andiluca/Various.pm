package Andiluca::Various;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');
use Term::ANSIColor ('color', 'colored');


# List of exported functions:
our @EXPORT_OK = ('parse_header', 'parse_decoration_divider', 'get_current_date_time_string', 'read_file', 'save_file', 'create_new_file_path');


# Parsing the whole header of the exam-file, using a regex:
#
# Parameters:
#   - $bare_content: Multi-line string which contains the unprocessed file-content of the exam file
# Returns:
#   - A multi-line string containing the header of the exam-file
sub parse_header($bare_content) {
    $bare_content =~ m/([^_]*[\t\n]*)/;
    return "$1";
}


# Parsing one decoration line (divider between the questions):
#
# Parameters:
#   - $bare_content: Multi-line string which contains the unprocessed file-content of the exam file
# Returns:
#   - A string containing the divider line
sub parse_decoration_divider($bare_content) {
    $bare_content =~ m/(_+)/;
    return "$1";
}


# Creates the needed current date time string:
# For help, see https://www.tutorialspoint.com/perl/perl_date_time.htm
#
# Parameters:
#   - none
# Returns:
#   - a string containing date and time in the format YYYYmmdd-hhmmss
sub get_current_date_time_string() {
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
    return(sprintf("%04d%02d%02d-%02d%02d%02d", 1900 + $year, 1 + $mon, $mday, $hour, $min, $sec));
}


# Reads the given file and returns its content:
#
# Parameters:
#   - $filepath: Path to the file
# Returns:
#   - a multi-line string containing the content of the given file
# Error Handling:
#   - Throws exception if file opening fails
sub read_file($filepath) {
    open my $fh, '<', $filepath or die colored(['red'], "Cannot read '$filepath': $!\n");
    my $bare_content = do {
        local $/;
        readline($fh)
    };
    close $fh;
    return $bare_content;
}


# Saves the given multi-line string to the given file-path
#
# Parameters:
#   - $filepath: Path to the file
# Error Handling:
#   - Throws exception if file saving fails
sub save_file($content, $file_path) {
    open(my $out_fh, ">", $file_path) // die colored([ 'red' ], "\nUnable to open file for write-access '$file_path':\n\t$!\n");
    say {$out_fh} $content;
    say colored([ 'green' ], "       Empty Exam-File created in '$file_path'.");
    close($out_fh);
}


# Constructs the file-path for the new file.
# The path is generally the same, but with an added subfolder 'Generated'.
# If the subfolder 'Generated' does not yet exist, it will be created.
# The file name gets prefixed with date and time.
# Sample input:
#     AssignmentDataFiles/MasterFiles/FHNW_entrance_exam_master_file_2017.txt
# Sample output would be:
#     AssignmentDataFiles/MasterFiles/Generated/20170904-132602-FHNW_entrance_exam_master_file_2017.txt
#
# Parameters:
#   - $filepath: Path to the file
# Returns:
#   - the new file-path for the output file
sub create_new_file_path($file_path) {
    # Create subdirectory /Generated, if not yet present:
    $file_path =~ m%(.*(.*/)*/)[^/]*$%;
    my $path_generated = $1 . "/Generated";
    if (!-d $path_generated) {
        mkdir ($path_generated);
    }

    # Generate date and time:
    my $date_and_time = get_current_date_time_string();

    # Create the path for the output-file:
    $file_path =~ s%/([^/]*)$%/Generated/$date_and_time-$1%;

    return $file_path;
}



1; # Magic true value that Perl requires for no good reason.
