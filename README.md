# Perl: (Semi-)automated Exam Assessment

#### Table of Content
- [General](#general)
  - [Team](#team)
- [Usage & Installation](#usage---installation)
  - [(CPAN-)modules Used](#-cpan--modules-used)
  - [Running the Scripts](#running-the-scripts)
- [High-Level Overview](#high-level-overview)
  - [Features](#features)
  - [Data Structure](#data-structure)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


---
## General
- This project is an assignment for the perl-course held by Dr. Damian Conway from Australia in summer 2020.
- In here, you find perl script for (semi-)automated assessment of a multiple choice exam in text format and the
creation of ready to use empty exam files generated from a 'master exam file', with randomized order of the answers.
- See [IntroPerl_project_specification_2020.pdf](IntroPerl_project_specification_2020.pdf) 
for extended project description.

### Team
- Andreas Ambühl - https://github.com/AndiSwiss
- Luca Fluri - https://github.com/lucafluri


---
## Usage & Installation

### (CPAN-)modules Used
- We used the following (CPAN-)modules. Please install them on your computer prior to use this software:
  - Data::Show
  - Exporter
  - Lingua::StopWords
  - List::Util
  - POSIX
  - Regexp::Grammars
  - Term::ANSIColor
  - Text::Levenshtein::Damerau
- We created custom modules -> in the folder `lib/Andiluca`. If you run the perl scripts from the project-root, then
these modules should be automatically detected and ready to use: For example `perl src/main.pl` should work, after you 
installed all required CPAN-Modules.

### Running the Scripts
- Apart from the installation of the above mentioned CPAN-Modules, 
- For creating empty tests (with randomized order of answers of each question), use the script `main.pl`:
  - If the user doesn't provide an argument, all the *.txt in the folder 'AssignmentDataFiles/MasterFiles/'
    are processed for this script: `perl src/main.pl`
  - The user can provide one or multiple files as parameter 
  - If you provide one argument, the script runs with the given file. Example: `perl src/main.pl AssignmentDataFiles/MasterFiles/short_exam_master_file.txt`
  - The generated empty tests will be created in a subfolder named `/Generated`, inside the directory of the provided file.
    Note: This subdirectory will be created if not already present.
- For generating the score of all the files, use the script `score.pl`:
  - First parameter: Master-file
  - Second parameter: Student-file(s)
  - Example: `perl src/score.pl AssignmentDataFiles/MasterFiles/FHNW_entrance_exam_master_file_2017.txt AssignmentDataFiles/SampleResponses/*`
  - Note: Calculating the score of many files can take a while, mostly because the distance-algorithms take some time.
- The script `statistics_stub.pl` is a helper file:
  - With this, you can quickly try the statistics functionality with some stub test data (no pre-calculations needed)


---

## High-Level Overview

### Features
- Create empty tests (with randomized order of answers of each question)
- Generate score(s) of the provided exam(s), including analysis and colored output of:
  - Filename (yellow)
  - 'Missing answer' (red)
  - 'Inexact match' (blue)
  - 'score' including correct and answered questions (green)
  - Note: we chose a colored output for easy identification of the various parts
- Statistics:
  - The statistics are generated and printed automatically when calculating the score(s) of file(s) 

### Data Structure


### General Code Structure


### Problems
