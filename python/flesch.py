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
	punctuation = {".", ":", ";", "!", "?"}
	if character in punctuation:
		return True
	return False
		

#####################################################################################
print("Enter the name of the input file: ")
inputFile = input()

#instantiate a list
words = []

#fill up the list with the words from the text file
words = tokenizeFile(inputFile)
numWords = totalWords(words)

print("Number of Words: ", numWords)

for w in words:
	print(w)


