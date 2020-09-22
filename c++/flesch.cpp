#include <iostream>
#include <fstream>
#include <vector>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
using namespace std;
void getWords(vector<string> &words, string input);
bool isNumber(string str);
bool findSentence (string word);
bool isPunctuation (char c);
int countSentences(vector<string> words);
int totalWords(vector<string>words);

int main ()
{
	string input;
	cout << "Enter the name of the input file: ";
	cin >> input;

	vector<string> words(1);
	
	
	getWords(words, input);
	int num = countSentences(words);
	int totWords = totalWords(words);
	cout << "Sentences: " << num << "\nWords : " << totWords;
	return 0;
}
void getWords(vector<string> &words, string input)
{
    ifstream file;
    file.open (input);
    if (!file.is_open()) return;

    string word;
    while (file >> word)
    {
 	if(!isNumber(word))
	       words.push_back(word);
    }
}

bool isNumber (string str)
{
	int counter = 0;
	
	//loop that increments the counter whtn the character is a digit
	for (int i = 0; i < str.size(); i++)
		if(isdigit(str[i]))
			counter++;
	
	//if the counter equals the size of the string, then the value
	//being stored in the string is a digit
	return (counter == str.size() ? true : false);
}

bool findSentence (string word)
{
	for (int i = 0; i < word.size(); i++)
	{
		if(isPunctuation(word[i]))	
			return true;		
	}
	return false;
}

bool isPunctuation (char c)
{
	char punctuation[] = {'.', ':', ';', '?', '!'};
	for(char p: punctuation)
		if(c==p) 
                	return true;
        
	return false;
}


int countSentences(vector<string> words)
{
	int numSentences = 0;

        for (int i = 0; i < words.size(); i++)
        {
        	if(findSentence(words[i]))
                	numSentences += 1;
        }
        return numSentences;
}

int totalWords(vector<string> words)
{
	//need the minus 1 because for some reason the first value in the vector is a space
	return words.size()-1;
}
