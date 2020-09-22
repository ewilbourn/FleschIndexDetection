#Emily Wilbourn
#Python flesch program

#define functions
def tokenizeFile(fileName):
  words = []
  with open(fileName,'r') as file: 
    # reading each line     
    for line in file: 
      # reading each word         
      for word in line.split(): 
        # displaying the words            
        words.append(word) 
  return words;

print("Enter the name of the input file: ")
inputFile = input()

words = []
words = tokenizeFile(inputFile)
for w in (words):
	print(w)
