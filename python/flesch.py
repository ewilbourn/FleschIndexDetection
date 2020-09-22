#Emily Wilbourn
#Python flesch program

#function to fill a list with all the words from a text file
def tokenizeFile(fileName):
    words = []
    with open(fileName,'r') as file: 
        #reading each line     
        for line in file: 
      	    #reading each word         
      	    for word in line.split(): 
                #if the word isn't a digit, add it to the list           
                if(not word.isdigit()):
	  	    words.append(word)
    return words;

print("Enter the name of the input file: ")
inputFile = input()

#instantiate a list
words = []

#fill up the list with the words from the text file
words = tokenizeFile(inputFile)


