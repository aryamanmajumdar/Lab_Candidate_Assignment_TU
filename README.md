# Lab_Candidate_Assignment_TU
For the Temple University Neuroeconomics and SDNL application

## 1. Figures

The required figures are all in the 'figures' folder.
They're both in JPEG and TIFF formats - JPEG for easy viewing
on GitHub, and TIFF to give you the raw image.

The 'individual' folder contains the individual effect plots.
The 'overall' folder contains bar plots showing the effect across subjects.

### Important
The 'overall_largerstderrs' folder contains the same bar plots, but
with a different calculation for standard errors - using all subjects
within a condition. This results in significant differences for some
figures where there were none in the original calculation; the reason
is that these stderr bars capture the overall effect size - i.e. they
might be valuable in predicting the trend for a sample, but doesn't speak
to the significance of the effect of individual subjects.
For that, just look at figures the 'overall' folder.

## 2. Code

The code is in 'temple_app.m'.
Note that the readmatrix() function that I used will only work in Matlab 2019a
and later versions. The older csvread() function is depreciated, so I thought
best not to use it.

The code does assume that subject IDs are numeric and ordinal. This is the only
'trickish' thing I did in the code. In the case that this doesn't hold, the code 
can be easily modified a bit to make it more general. Hopefully, this won't cost 
me the job!
