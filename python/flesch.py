#!/usr/bin/python3
#Emily Wilbourn
#Python flesch program


#importing sys so that I can receive command line input
import sys

#function to fill a set with all the words from a text file amd return number of sentences
#precondition: pass in the file name (string) and the set we want to update
#postcondition: returns the number of sentences in a word and updates our set
def tokenizeFile(words, fileName):
	numSentences = 0
	with open(fileName,encoding='utf8',errors='ignore') as file: 
		for line in file:
			for word in line.split():
				if (not word.isdigit()):
					for char in word:
						if findPunctuation(char):
							numSentences+=1
							word = word.replace(char,"")
						#remove unwanted characters from the file
						if char in ",[]" or char == "'":
							word = word.replace(char,"")
					words.append(word.lower())
					#print(word.lower())
	return numSentences

	
#function to determine if a word has punctuation
#precondition: pass in the word being stored in a list of strings
#postcondition: return True if there is punctuat
def findPunctuation(character):
	punctuation = ".:;!?"
	if character in punctuation:
		return True
	return False

#function to determine if a character is a vowel
#precondition: pass in a character
#postcondition: return True is the character is a vowel, False if it isn't
def findVowel(character):
	vowels = "aeiouy"
	if character in vowels:
		return True
	return False

#function to count the number of syllables in a word (string)
#precondition: pass in a word (string)
#postcondition: return the number of syllables in a word (integer)
def findSyllables(word):
	syllables = 0
	try:
		if findVowel(word[0]):
			syllables+=1
	except:	
		syllables = 0
	for i in range(1, len(word)):
	#this handles when the word ends in an e (which is silent, and thus not a syllable)
		if(not ((word[i]).lower() == 'e' and i == (len(word)-1))):
			#handles two vowels in a row
			#i.e. spool, cool, moon
			if findVowel(word[i]) and not findVowel(word[i-1]):
				syllables+=1
				
	if syllables == 0:
		syllables = 1

	return syllables

#function to count the number of syllables in the file
#precondition: pass in the list of words (strings)
#postcondition: return the number of syllables in the text file (integer)
def totalSyllables(words):
	numSyllables = 0
	for word in words:
		numSyllables += findSyllables(word)	
	
	return numSyllables

#function to create a list of Dale Chall words
#precondition: pass in nothing
#postcondition: return the set of words (strings)
def createDaleChallList():
	daleChall = []
	with open("/pub/pounds/CSC330/dalechall/wordlist1995.txt",encoding='utf8',errors='ignore') as file:
		for line in file:
			for word in line.split():
				for char in word:
					if char == "'":
						word = word.replace("'","")
				daleChall.append(word.lower())
	daleChall.sort()
	return daleChall

#function to quickly find values in list
#precondition: pass in the list of words (string) and the key we're looking for (string)
#postcondition: return the location of the key in list; if key isn't in list, return -1
def binarySearch(wordList,key):
	first = 0
	last = len(wordList)-1
	found = False
	while (first<=last and not found): 
		mid = (first+last)//2
		if wordList[mid] == key:
			found = True
		else:
			if key < wordList[mid]:
				last = mid - 1
			else:
				first = mid + 1
	return found

#function to count the number of challenging words in a text file based on the Dale Chall List
#precondition: pass in the set of words (strings)
#postcondition: return the number of challenging words (integer)
def countChallengingWords(words):
	difficultWords = 0
	daleChall = []
	daleChall = createDaleChallList()
	daleChall = set(daleChall)
	for word in words:
		if (word not in daleChall):
			difficultWords+=1
	return difficultWords

#function to calculate the flesch-kincaid readability index
#precondition: pass in the set of words (string)
#postcondition: returns the flesch-kincaid readability index (float to 1 decimal place)
def fleschKincaidIndex(words, numSentences):
	numWords = len(words)
	totalSyll = totalSyllables(words)

	#these are floats
	a = totalSyll/numWords
	b = numWords/numSentences

	#index is a float
	index = (a*11.8) + (b*0.39) - 15.59

	#return the index (float) rounded to 1 decimal place
	return round(index, 1)


#function to calculate the flesch readability index
#precondition: pass in the list of words (string)
#postcondition: returns the flesch index (integer)
def fleschIndex(words, numSentences):
        numWords = len(words)
        totalSyll = totalSyllables(words)

	#these are floats
        a = totalSyll/numWords
        b = numWords/numSentences

	#return the index (float) rounded to 1 decimal place
        return round((206.835 - (a*84.6) - (b*1.015)))

#function to calculate the Dale-Chall Index
#precondition: pass in the list of words (string)
#postcondition: returns the Dale-Chall Index (float rounded to 1 decimal place)
def daleChallIndex(words, numSentences):
	numWords = len(words)
	difficultWords =  countChallengingWords(words)

	#these are floats
	a = difficultWords/numWords
	b = numWords/numSentences
	index = ((a*100)*0.1579)+(b*0.0496)
	if((a*100) > 5):
		index += 3.6365;

	#return the index (float) rounded to 1 decimal place
	return round(index, 1);



#####################################################################################

def main():
	#receives command line input for the file name
	#command to enter for KJV.txt: python3 flesch.py KJV
	#here, KJV will be stored in inputF
	inputF = str(sys.argv[1])

	
	inputFile = "/pub/pounds/CSC330/translations/" + inputF + ".txt"

	#instantiate a list
	words = []

	#fill up the list with the words from the text file
	numSentences = tokenizeFile(words,inputFile)
	numWords = len(words)
	numSyllables = totalSyllables(words)
	numChallWords = countChallengingWords(words)
	daleChall = daleChallIndex(words, numSentences)
	flesch = fleschIndex(words, numSentences)
	fleschKincaid = fleschKincaidIndex(words, numSentences)
	
	if(len(inputF) == 3):
		print("Python    " , inputF, "         " , flesch, "     ", fleschKincaid, "            ", daleChall,"          ");

	if(len(inputF) == 4):
		print("Python    " , inputF, "        " , flesch, "     ", fleschKincaid, "            ", daleChall,"          ");
	if(len(inputF) == 5):
		print("Python    " , inputF, "       " , flesch, "     ", fleschKincaid, "            ", daleChall,"          ");
#################################################################################

main()

