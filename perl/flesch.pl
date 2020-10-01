#!/usr/bin/perl
use strict;
use warnings;
use 5.010;
use Scalar::Util qw(looks_like_number);

#define a subroutine for a binary search
sub binSearch
{

}




# Grab the name of the file from the command line, exit if no name given
my $filename = $ARGV[0] or die "Need to get file name on the command line\n";

# Use the filename
open(DATA, "<$filename") or die "Couldn't open file $filename, $!";

#open my $d_c, '<', "pub/pounds/CSC330/dalechall";
#chomp(my @dale_chall = <$d_c>);
#close $d_c;

#my $data_d_c = "pub/pounds/CSC330/dalechall";

#"/pub/pounds/CSC330/dalechall";
# Open the Dale-Chall list and collect the data inside it
open(DATA1, "<", "/pub/pounds/CSC330/dalechall/wordlist1995.txt") or die "Couldn't open file $filename, $!";

#create an array that holds all the words in the dale-chall list
my @dale_chall = <DATA1>;

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

#array that holds other characters that we need to 
#remove from the words we are reading in
my @other_punctuation = ("[", ",", "]");

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
				for my $other_punct(@other_punctuation)
				{	
					$token =~ s/\Q$char// if (($char cmp $other_punct) == 0);
				}
			}
		}
		#make the token, aka the word, all lowercase
		my $token1 = lc $token;

		#if the token, aka the word, doesn't look like a number,
		#then put it into the array of words
		push(@all_words, $token1) if(!looks_like_number($token));
	}
}

#initialize variable to hold the number of difficult words
my $difficult_word_count = 0;
my @new_dale_chall = ();
#loop to fill up an array with the Dale-Chall words
foreach my $line (@dale_chall)
{
        my @tokens = split(' ', $line);
        foreach my $token (@tokens)
        {
		#make the token, aka the word, all lowercase
		my $token1 = lc $token;
		push(@new_dale_chall, $token1);
	}
}

@new_dale_chall = sort{$a cmp $b} @new_dale_chall;
#calculate the number of difficult words in the text file
#by comparing the contents to the dale-chall list
foreach my $key(@all_words)
{

	my $low = 0;
	my $mid;
	my $found_key = 0;
	my $high = $#new_dale_chall;
	my $index;
		
	while( ( $low <= $high ) && !$found_key ) 
	{
  		$mid =int( ( $low + $high ) / 2);
  		if(( $key cmp $new_dale_chall[$mid] ) == 0)
		{
    			$found_key = 1;
    			$index = int( $mid );
  		}

  		elsif(( $key cmp $new_dale_chall[$mid] ) < 0)
		{
    			$high = $mid - 1;
  		}

  		else 
		{
    			$low = $mid + 1;
  		}
	}

	if( $found_key ) 
	{
	}

	else 
	{
		$difficult_word_count++;	
	}
	
}


#print the word count
#print "\nWord Count: ", "$word_count";


#print the sentence count
#print "\nSentence Count: ", "$sentence_count";

print "\nDifficult Words: ", "$difficult_word_count";
#print "@new_dale_chall\n";
#print"\n";

