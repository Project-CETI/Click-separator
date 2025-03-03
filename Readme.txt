A program written in Matlab for detecting and separating sperm whales echolocation clicks 
The code requires installing a Matlab addon called: MinGW-w64 C/C++/Fortran Compiler


To run the code, please open Click_separator.m and press the 'run' bottom
A dialouge box will be opened where you can enter the folder of the desired
 recordings. 

The output of the script is a structure called "Det". This strcture stores the arrival time of clicks of each detected whale.
For example, the clicks' arrival time of the second whale are given in: Det(2).ToAs'. In addition, the 
output will be saved automatically as a csv file with the same name as the audio
