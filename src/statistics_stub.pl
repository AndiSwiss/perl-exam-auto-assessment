#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Andiluca::Statistics('print_statistics');


# This file is for quickly testing statistics functionality without analyzing the tests first:
my @correct_answers_count_total = (28, 23, 27, 22, 20, 28, 28, 28, 23, 16, 24, 22, 25, 26, 20, 25, 3,
    24, 24, 19, 23, 25, 28, 28, 24, 20, 21, 26, 14, 21, 20, 24, 23, 27, 28, 27);
my @answered_questions_count_total = (30, 30, 30, 30, 30, 30, 30, 30, 29, 19, 30, 29, 30, 30, 30, 30,
    4, 30, 30, 26, 30, 30, 30, 30, 30, 29, 30, 30, 14, 30, 30, 30, 30, 30, 30, 30);

print_statistics(\@correct_answers_count_total, \@answered_questions_count_total);
