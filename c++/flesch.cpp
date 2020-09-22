#include <iostream>
#include <fstream>
#include <vector>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <algorithm>
#include <cmath>
using namespace std;
void getWords(vector<string> &words, string input);
bool isNumber(string str);
bool findSentence (string word);
bool isPunctuation (char c);
int countSentences(vector<string> words);
int totalWords(vector<string>words);
bool isVowel(char c);
int numSyllables (string word);
int totalSyllables(vector <string> words);
vector <string> createDaleChallList();
int challengingWords(vector <string> words);
double fleschKincaidIndex(vector <string> words);
int fleschIndex(vector<string>words);
int main ()
{
	string input;
	cout << "Enter the name of the input file: ";
	cin >> input;

	vector<string> words(1);
	
	
	getWords(words, input);
	int num = countSentences(words);
	int totWords = totalWords(words);
	int syll = totalSyllables(words);
	int difficultWords = challengingWords(words);
	cout << "Sentences: " << num << "\nWords : " << totWords << "\nSyllables: " << syll << "\nDifficult Words: " << difficultWords;
	
	vector <string> daleChall = createDaleChallList();
	int sizeDale = daleChall.size()-1;
	cout << "\nSize of Dale Chall: " << sizeDale;

	int flesch = fleschIndex(words);
        double flesch_kincaid = fleschKincaidIndex(words);
        //double dale_chall = daleChallIndex(words);
        cout << "Flesch Readability Index: " << flesch << "\nFlesch-Kincaid Grade Level Index: " << flesch_kincaid/* + "\nDale-Chall Readability Score: " + dale_chall*/;
                
	return 0;
}

//method to add all the words to a vector
//precondition: pass in the empty vector that we're filling and the name of the file we're opening
//postcondition: nothing is returned, but the vectors is updated
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

//method to determine if a string is holding a number
//precondition: pass in the string
//postcondition: return true if we have a number, false if we don't (boolean)
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

//method that determines if we have a sentence
//precondition: pass in a string
//postcondition: return true if there is punctuation in the string, false if there is not(boolean)
bool findSentence (string word)
{
	for (int i = 0; i < word.size(); i++)
	{
		if(isPunctuation(word[i]))	
			return true;		
	}
	return false;
}

//method that determines if a char is punctuation or not
//precondition: pass in the character
//postcondition: return true if the character is punctuation, false if it isn't (boolean)
bool isPunctuation (char c)
{
	char punctuation[] = {'.', ':', ';', '?', '!'};
	for(char p: punctuation)
		if(c==p) 
                	return true;
        
	return false;
}

//method to count the number of sentences in a text file
//precondition: pass in the vector of words (strings)
//postcondition: return the total number of sentences in the file (integer)
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

//method to return the total number of words in a text file
//precondition: pass in the vector of words (strings)
//postcondition: return the number of words in the text file (integer)
int totalWords(vector<string> words)
{
	//need the minus 1 because for some reason the first value in the vector is a space
	return words.size()-1;
}

//method to determine if a character is a vowel
//precondition: pass in a letter (char)
//postcondition: return true if the letter is a vowel, false if it is not (boolean)
bool isVowel(char c)
{
	char vowels[] = {'a', 'e', 'i', 'o', 'u','y'};
        for(char vowel:vowels)
        {
        	if (tolower(c) == vowel)
                	return true;
        }

        return false;
}

//method to count the number of syllables in the a word
//precondition: pass in the word (string)
//postcondition: return the number of syllables (integer)
int numSyllables(string word)
{
	int syllables = 0;

        for (int i = 0; i < word.length(); i++)
        {
		//this handles when the word ends in an e (which is silent, and thus not a syllable)
        	if(!((i+1) == word.length() && tolower(word[i]) == 'e'))
                {
                	if(isVowel(word[i]))
                        {
                        	syllables++;
				//handles two vowels in a row
				//i.e. spool, cool, moon
                                if ((i+1)< word.length() && isVowel(word[i+1]))
                                	i++;
                        }
              	}
       	}
        return syllables;
}

//method to count the total number of syllables in a text file
//precondition: pass in the vector of words (string)
//postcondition: return the number of syllables in a file (integer)
int totalSyllables(vector <string> words)
{
	int syllables = 0;
        for(int i = 0; i < words.size(); i++)
        {
        	syllables += numSyllables(words[i]);
        }
        return syllables;
}

//method to create a vector of the words found in the Dale-Chall list
//precondition: pass nothing in
//postcondition: return the vector of words (string)
vector<string> createDaleChallList() 
{
	vector<string> daleChall (1);
        getWords(daleChall, "/pub/pounds/CSC330/dalechall/wordlist1995.txt");
        return daleChall;
}

//method to count the number of challenging words in a text file
//precondition: pass in the vector of words (string) that make up the file
//postcondition: return the number of challenging words in the file (integer)
int challengingWords(vector <string> words)
{
	int difficultWords = 0;
        vector <string> wordList = createDaleChallList();
        for (int i = 0; i < words.size(); i++)
        {
        	bool found = binary_search(wordList.begin(), wordList.end(), words[i]);
                if (found != false)
                	difficultWords++;
        }
        return difficultWords;
}

double fleschKincaidIndex(vector<string>words)
{
	int numSentences = countSentences(words);
        int numWords = totalWords (words);
        int totalSyll = totalSyllables(words);
        double a = ((double)totalSyll/(double)numWords);
        double b = ((double)numWords/(double)numSentences);

        double index = (a*11.8) + (b*0.39) - 15.59;
        return (round(index)*10)/10.0;
}

int fleschIndex(vector<string>words)
{
	int numSentences = countSentences(words);
        int numWords = totalWords (words);
        int totalSyll = totalSyllables(words);

        double a = ((double)totalSyll/(double)numWords);
        double b = ((double)numWords/(double)numSentences);

        return round((206.835 - (a*84.6) - (b*1.015)));
}

