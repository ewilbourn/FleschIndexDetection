#Emily Wilbourn
#Python flesch program
from bisect import bisect_left

#function to fill a list with all the words from a text file
#precondition: pass in the file name (string)
#postcondition: returns the list of words
def tokenizeFile(words, fileName):
	numSentences = 0
	with open(fileName,encoding='utf8',errors='ignore') as file: 
		for line in file:
			for word in line.split():
				if (not word.isdigit()):
					for char in word:
						if findPunctuation(char):
							numSentences+=1
					words.append(word.lower())
	return numSentences

	
#function to determine if a word has punctuation
#precondition: pass in the word being stored in a list of strings
#postcondition: return True if there is punctuat
def findPunctuation(character):
	punctuation = {'.', ':', ';', '!', '?'}
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
	for i in range(len(word)):
	#this handles when the word ends in an e (which is silent, and thus not a syllable)
		if(not ((i+1) == len(word) and (word[i]).lower() == 'e')):
			if findVowel(word[i]):
				syllables+=1
				#handles two vowels in a row
				#i.e. spool, cool, moon
				if ((i+1)< len(word) and findVowel(word[i+1])):
					i+=1
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
#postcondition: return the list of words (strings)
def createDaleChallList():
	daleChall = []
	with open("/pub/pounds/CSC330/dalechall/wordlist1995.txt",encoding='utf8',errors='ignore') as file:
                for line in file:
                        for word in line.split():
                        	daleChall.append(word.lower())


	daleChall.sort()
	return daleChall

#function to quickly find values in list
#precondition: pass in the list of words (string) and the key we're looking for (string)
#postcondition: return the location of the key in list; if key isn't in list, return -1
def binarySearch(wordList,key):
	low = 0
	high = len(wordList)-1
	while low <= high: 
		mid = (low+high)//2
		if wordList[mid] > key: high = mid-1
		elif wordList[mid] < key: low = mid+1
		else: return mid
	return -1

#function to count the number of challenging words in a text file based on the Dale Chall List
#precondition: pass in the list of words (strings)
#postcondition: return the number of challenging words (integer)
def countChallengingWords(words):
	difficultWords = 0
	daleChall = []
	daleChall = createDaleChallList()
	for word in words:
		 if (binarySearch(daleChall,word) == -1):
			 difficultWords+=1
	return difficultWords

#function to calculate the flesch-kincaid readability index
#precondition: pass in the list of words (string)
#postcondition: returns the flesch-kincaid readability index (float to 1 decimal place)
def fleschKincaidIndex(words):
	numSentences = totalSentences(words)
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
def fleschIndex(words):
        numSentences = totalSentences(words)
        numWords = len(words)
        totalSyll = totalSyllables(words)

	#these are floats
        a = totalSyll/numWords
        b = numWords/numSentences

	#return the index (float) rounded to 1 decimal place
        return round((206.835 - (a*84.6) - (b*1.015)),1)

#function to calculate the Dale-Chall Index
#precondition: pass in the list of words (string)
#postcondition: returns the Dale-Chall Index (float rounded to 1 decimal place)
def daleChallIndex(words):
	numSentences = totalSentences(words)
	numWords = len(words)
	difficultWords =  countChallengingWords(words)

	#these are floats
	a = difficultWords/numWords
	b = numWords/numSentences
	index = ((a*100)*0.1579)+(b*0.0496)
	if(a < 0.05):
		index += 3.6365;

	#return the index (float) rounded to 1 decimal place
	return round(index, 1);



#####################################################################################

def main():
	print("Enter the name of the input file: ")
	inputFile = input()

	#instantiate a list
	words = []

	#fill up the list with the words from the text file
	numSentences = tokenizeFile(words,inputFile)
	numWords = len(words)
	numSyllables = totalSyllables(words)
	numChallWords = countChallengingWords(words)
	daleChall = daleChallIndex(words)
	flesch = fleschIndex(words)
	fleschKincaid = fleschKincaidIndex(words)

	print("Number of Words: ", numWords)
	print("Number of Sentences: ", numSentences)
	print("Number of Syllables: ", numSyllables)
	print("Number of Challenging Words: ", numChallWords)
	print("Flesch Index: ", flesch)
	print("Flesch-Kincaid Index: ", fleschKincaid)
	print("Dale Chall Index: ", daleChall)
#################################################################################

main()
