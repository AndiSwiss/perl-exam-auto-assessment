#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;

# use File::Path;    # TODO:  maybe implement this for consistent behaviour on windows?
use Andiluca::Useful ("title", "assert");

# ------------------------------ #
# Basic code for reading a file: #
# ------------------------------ #
my $file = "short_exam_master_file.txt";
my $path = "AssignmentDataFiles/MasterFiles/" . $file;

open my $fh, '<', $path or die "Cannot read '$path': $!\n";

say "\nFile '$file' has the following content:\n";

while (<$fh>) {
    # NOTE: 'chomp' strips away '\n' of each line.
    # You can see this very nicely if you use the debugger and track the variable '$_'!
    chomp;
    say $_;
}

close $fh;

# Testing title and assert-functionality:
title("Using title module:");
assert("true", "true", "simple test");
