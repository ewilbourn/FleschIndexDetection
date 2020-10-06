#!/usr/bin/perl
#Emily Wilbourn
#Perl flesch program

use strict;
use warnings;

#using this to determine if a character is a number or not when 
#reading in input from the text file
use Scalar::Util qw(looks_like_number);


# Grab the name of the file from the command line, exit if no name given
#just take in the name of the file, not the whole path
#i.e. perl flesch.pl KJV
my $name = $ARGV[0] or die "Need to get file name on the command line\n";


#variable to hold the full file path
my $filename = '/pub/pounds/CSC330/translations/' . $name . '.txt';

# Use the filename
open(DATA, "<$filename") or die "Couldn't open file $filename, $!";


# Open the Dale-Chall list and collect the data inside it
open(DATA1, "<", "/pub/pounds/CSC330/dalechall/wordlist1995.txt") or die "Couldn't open file $filename, $!";

#create an array that holds all the words in the dale-chall list
my @dale_chall = <DATA1>;

#The next line puts all the lines from the text file into an array called @all_lines
my @all_lines = <DATA>;

close DATA;
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

#define a vowel list that we will use to find vowels in words
my @vowel_list = ("a","e","i","o","u","y");
my $syllable_count = 0;



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

#loop to count the number of syllables in the file
my $total_syll_count = 0;
for my $word (@all_words)
{
	$syllable_count = 0;
	my @chars = split("", $word);
	for my $v (@vowel_list)
	{
		#if the first character in a word is defined, then determine if it 
		#is a vowel or not 
		if (defined $chars[0])
		{
			$syllable_count++ if (($chars[0] cmp $v)==0);
		}        
	}
	for (my $i = 1; $i < $#chars; $i++) 
	{
        	my $char = $chars[$i];
		my $prev_char = $chars[$i-1];
		#this handles when the word ends in an e (which is silent, and thus not a syllable)
        	
		if(not (($char cmp 'e') == 0 and $i == ($#chars-1)) and (defined $char))
		{
        		#handles two vowels in a row
        		#i.e. spool, cool, moon
        		for my $v (@vowel_list)
                        {
                         	       
				$syllable_count++ if(($char cmp $v) == 0 && ($prev_char cmp $v) !=0);
			}
        	}
	}
	if ($syllable_count == 0)
	{
        	$syllable_count = 1
	}
	
	$total_syll_count += $syllable_count;
	
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
#by comparing the contents to the dale-chall list by utilizing a 
#binary search
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


#calculate flesch readability index
my $a1 = ($total_syll_count)/($word_count);
my $b1 = ($word_count)/($sentence_count);
my $flesch_index = 206.835-(($a1)*84.6)-($b1)*(1.015);

#round the flesch index to the nearest integer
my $round_f = sprintf("%.0f",$flesch_index);

#calculate flesch-kincaid readability index
my $flesch_kincaid = ($a1)*11.8+($b1)*0.39-15.59;

#round the flesch-kincaid index to one decimal place
my $round_fk = sprintf("%.1f", $flesch_kincaid);

#calculate dale-chall index
my $a = ($difficult_word_count)/($word_count);
my $b = ($word_count)/($sentence_count);

my $d_c_index = (($a*100)*0.1579)+(($b)*0.0496);
$d_c_index = $d_c_index+3.6365 if(($a*100) > 5);

#round the dale-chall index to one decimal place
my $round_dc = sprintf("%.1f", $d_c_index);


#print out the output based on the length of the filename we read in on the command line 
print "Perl       " , $name, "           " , $round_f, "       ", $round_fk, "              ", $round_dc,"          " if (length($name) == 3);
print "Perl       " , $name, "          " , $round_f, "       ", $round_fk, "              ", $round_dc,"          " if (length($name) == 4);
print "Perl       " , $name, "         " , $round_f, "       ", $round_fk, "              ", $round_dc,"          " if (length($name) == 5);
print"\n";

