#!/usr/bin/perl
use strict;
use warnings;


use Scalar::Util qw(looks_like_number);

#all lines is all the lines in the array; splits the line by spaces and 


# Grab the name of the file from the command line, exit if no name given
my $filename = $ARGV[0] or die "Need to get file name on the command line\n";

# Use the filename
open(DATA, "<$filename") or die "Couldn't open file $filename, $!";

#The next line puts all the lines from the text file into an array called @all_lines
my @all_lines = <DATA>;

#array to hold individual words
my @all_words = ();

#create a variable that will count the words
my $word_count = 0;

#Now take each line and break it into tokens based on spaces and print the token
foreach my $line (@all_lines)
{
	my @tokens = split(' ', $line);
	foreach my $token (@tokens)
	{
		push(@all_words, $token) if(!looks_like_number($token));

		#increment the word counter variable
		$word_count++ if(!looks_like_number($token));
	}
}

#print out the contents of word array
print "@all_words\n";

#print the word count
print "$word_count";
