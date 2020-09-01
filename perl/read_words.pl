#!/usr/bin/perl
use strict;
use warnings;

#Grab the name of the file from the command line, exit if no name given
#ARGV looks similar to ARGC in c++; if it's not there, don't run (aka die) and spit out message
my $filename = $ARGV[0] or die "Need to get file name on the command line\n";

#use the filename
open(DATA, "<$filename") or die "Couldn't open file $filename, $!";

#the next line puts all the lines from the textfile into an arrray called @lines
my @lines = <DATA>; #this is an array called lines; perl is great for processing data

print @lines;




