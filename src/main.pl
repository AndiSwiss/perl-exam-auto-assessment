#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;


# ------------------------------ #
# Basic code for reading a file: #
# ------------------------------ #
my $file = "short_exam_master_file.txt";
my $path = "AssignmentDataFiles/MasterFiles/" . $file;

open my $fh, '<', $path or die "Cannot read '$path': $!\n";

say "\nFile '$file' has the following content:\n";

while (<$fh>) {
    chomp;
    say $_;
}

close $fh;
