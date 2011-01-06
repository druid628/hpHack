#!/usr/bin/perl
print <<EOJ
\e%-12345X\@PJL JOB
\@PJL RDYMSG DISPLAY="@ARGV"
\@PJL EOJ
\e%-12345X
EOJ

$ perl myscript.pl "WHATEVER MESSAGE" | lpr -l
