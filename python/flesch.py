#Emily Wilbourn
#Python flesch program

#define functions
def readFile(fileName):
	with open(fileName,'r') as file: 
    	  # reading each line     
     	  for line in file: 
            # reading each word         
            for word in line.split(): 
              # displaying the words            
              print(word)  


print("Enter the name of the input file: ")
inputFile = input()
readFile(inputFile)
