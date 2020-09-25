package Andiluca::Exam_Parser;
#!/usr/bin/env perl
use v5.32;
use warnings;
use diagnostics;
use experimental ('signatures');
use Exporter ('import');
use Regexp::Grammars;               # Module for using Grammars in Regex


our @EXPORT_OK = ('parsing_exam');  # List of exported functions


sub parsing_exam($bare_content) {

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
            \s*\d+ \.

        <token: text>
            \N* \n                  # First line of text may be anything
            (?: \N* \S \N* \n )*?   # Extra lines of text must contain a non-space
                                    # The ? at the end modifies the * (0 or more) to "use the one with the least amount ???

        <token: checkbox>
            \[ \s*[^\]]*\s* \]

        <token: decoration>
            \N* \n

        <token: empty_line>
            \s* \n
    }xms;


    # Run the regex-grammar to create the hash-object:
    if ($bare_content =~ $exam_parser) {
        # NOTE: '%/' is a special variable from the Regexp-module to fetch the created data-structure:
        my %parsed = %/;
        return(\%parsed);
    }

    # If not successful, throw a warning:
    else {
        die "Error with parsing the exam-file: Not a valid exam file!";
    }
}






1; # Magic true value that Perl requires for no good reason.

