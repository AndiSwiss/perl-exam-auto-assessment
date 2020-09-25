# perl-exam-auto-assessment
This is a small perl script for (semi-)automated assessment of a multiple choice exam in text format.

This project is an assignment for the perl-course held by Dr. Damian Conway from Australia in summer 2020.

See [IntroPerl_project_specification_2020.pdf](IntroPerl_project_specification_2020.pdf) 
for extended project description.

## Team
Andreas Ambühl - https://github.com/AndiSwiss
Luca Fluri - https://github.com/lucafluri



### Caveats
There is one file which behaves very different on the computer of Luca (with Ubuntu) and my computer (macOS):
If we both run the command 
`perl src/score.pl AssignmentDataFiles/MasterFiles/FHNW_entrance_exam_master_file_2017.txt AssignmentDataFiles/SampleResponses/20170828-092520-FHNW_entrance_exam-ID039411` (which compares the exam-file with id "ID039411" with the master-file), we get a different result, which we could not 
find an explanation for.
