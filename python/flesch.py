#Emily Wilbourn
#Python flesch program

#function to fill a list with all the words from a text file
#precondition: pass in the file name (string)
#postcondition: returns the list of words
def tokenizeFile(fileName):
	words = []
	with open(fileName,'r') as file: 
		for line in file: 
			for word in line.split(): 
				if(not word.isdigit()):
					words.append(word) #if the word isn't a digit, add it to the list           
	return words;

#function to count the number of words in a file
#precondition: pass in the list of words
#postcondition: return the length of the list of words (integer)
def totalWords(words):
	return len(words)

#function to determine if a word has punctuation
#precondition: pass in the word being stored in a list of strings
#postcondition: return True if there is punctuat
def findPunctuation(character):
	punctuation = {'.', ':', ';', '!', '?'}
	if character in punctuation:
		return True
	return False

#function to count the number of sentences 
#precondition: pass in the list of words (string)
#postcondition: return the number of sentences in the file (integer)	
def totalSentences(words):
	numSentences = 0
	for word in words:
		for char in word:
			if(findPunctuation(char)):
				numSentences+=1
	return numSentences

#function to determine if a character is a vowel
#precondition: pass in a character
#postcondition: return True is the character is a vowel, False if it isn't
def findVowel(character):
	vowels = {'a', 'e', 'i', 'o', 'u', 'y'}
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
        daleChall = tokenizeFile("/pub/pounds/CSC330/dalechall/wordlist1995.txt")
        return daleChall;

#function to count the number of challenging words in a text file based on the Dale Chall List
#precondition: pass in the list of words (strings)
#postcondition: return the number of challenging words (integer)
def countChallengingWords(words):
	difficultWords = 0
	daleChall = []
	daleChall = createDaleChallList()
	for word in words:
		 if word in daleChall:
			 difficultWords+=1
	return difficultWords

#####################################################################################
print("Enter the name of the input file: ")
inputFile = input()

#instantiate a list
words = []

#fill up the list with the words from the text file
words = tokenizeFile(inputFile)
numWords = totalWords(words)
numSentences = totalSentences(words)
numSyllables = totalSyllables(words)
numChallWords = countChallengingWords(words)

print("Number of Words: ", numWords)
print("Number of Sentences: ", numSentences)
print("Number of Syllables: ", numSyllables)
print("Number of Challenging Words: ", numChallWords)

for w in words:
	print(w)


