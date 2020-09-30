#!/usr/bin/perl
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

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

#create a variable that will count the sentences
my $sentence_count = 0;

#instantiate an array that holds all the punctuation
my @punctuation = (".", ";", ":", "!", "?");

#Now take each line and break it into tokens based on spaces and print the token
foreach my $line (@all_lines)
{
	my @tokens = split(' ', $line);
	foreach my $token (@tokens)
	{
		#instantiating a character array where each index is a character
		#in the word we are currently looking at
		my @char_array = split(//, $token);


		#increment the word counter variable
		$word_count++ if(!looks_like_number($token));
		for my $char(@char_array)
		{
			for my $punct (@punctuation)
			{
				$sentence_count++ if(($char cmp $punct) == 0);
				$token =~ s/\Q$char// if (($char cmp $punct) == 0);
			}
		}
		#if the token, aka the word, doesn't look like a number,
		#then put it into the array of words
		push(@all_words, $token) if(!looks_like_number($token));
	}
}

#print out the contents of word array
print "@all_words\n";

#print the word count
print "\nWord Count: ", "$word_count";


#print the sentence count
print "\nSentence Count: ", "$sentence_count";

print"\n";
