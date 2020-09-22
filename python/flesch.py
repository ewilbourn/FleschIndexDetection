#Emily Wilbourn
#Python flesch program

#function to fill a list with all the words from a text file
def tokenizeFile(fileName):
	words = []
	with open(fileName,'r') as file: 
		for line in file: 
			for word in line.split(): 
				if(not word.isdigit()):
					words.append(word) #if the word isn't a digit, add it to the list           
	return words;


def totalWords(words):
	return len(words)

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
