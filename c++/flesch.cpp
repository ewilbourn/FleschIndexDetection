#include <iostream>
#include <fstream>
#include <vector>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <algorithm>
#include <cmath>
#include <iomanip>

using namespace std;
void getWords(vector<string> &words, string input, int &numSentences, int &numWords);
bool isNumber(string str);
int totalWords(vector<string>words);
bool isVowel(char c);
bool isPunctuation (char c);
int numSyllables (string word);
int totalSyllables(vector <string> words);
vector <string> createDaleChallList();
int difficultWords(vector <string> words);
double fleschKincaidIndex(vector <string> words, int numSentences, int totalWords);
int fleschIndex(vector<string>words, int numSentences, int totalWords);
double daleChallIndex(vector<string> words,int numSentences, int totalWords);

int main (int argc, char *argv[])
{
	string input;
	//cout << "Enter the name of the input file: ";
	//cin >> input;
        input = argv[1];
	vector<string> words(1);
	
	int numSentences = 0;
	int totalWords = 0;
	getWords(words, input, numSentences, totalWords);
	int syll = totalSyllables(words);
	int hardWords = difficultWords(words);
	cout << "Sentences: " << numSentences << "\nWords : " << totalWords << "\nSyllables: " << syll << "\nDifficult Words: " << hardWords;
	
	int flesch = fleschIndex(words, numSentences, totalWords);
        double flesch_kincaid = fleschKincaidIndex(words, numSentences, totalWords);
        double dale_chall = daleChallIndex(words, numSentences, totalWords);
        cout << "\nFlesch Readability Index: " << flesch << "\nFlesch-Kincaid Grade Level Index: ";
	cout << fixed << setprecision(1);
	cout << flesch_kincaid;
	cout << "\nDale-Chall Readability Score: " << dale_chall << endl;
                
	return 0;
}

//method to add all the words to a vector
//precondition: pass in the empty vector that we're filling and the name of the file we're opening
//postcondition: nothing is returned, but the vectors is updated
void getWords(vector<string> &words, string input, int &numSentences, int &numWords)
{
    ifstream file;
    file.open (input);
    if (!file.is_open()) return;

    string word;
    while (file >> word)
    {
	//for loop to count the number of sentences
	for (int i = 0; i < word.size(); i++)
        {
                if(isPunctuation(word[i]))
                {			
			numSentences+=1;
		}
        }

	//for loop to remove punctuation from words before adding them to the vector
	string punctuation = ".,:;!?[]";
	for (char c: punctuation) 
	{
		word.erase(std::remove(word.begin(), word.end(), c), word.end());
	}


 	if(!isNumber(word))
	{
		transform(word.begin(), word.end(), word.begin(), ::tolower); 	 
		words.push_back(word);
		numWords+=1;
	}
    }
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
	if(syllables == 0)
		syllables = 1;
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
 	ifstream file;
        file.open ("/pub/pounds/CSC330/dalechall/wordlist1995.txt");

        string word;
        while (getline(file,word))
        {
		transform(word.begin(), word.end(), word.begin(), ::tolower);
		daleChall.push_back(word);	
	}

 	sort(daleChall.begin(), daleChall.end());
	
        return daleChall;
}

//method to count the number of challenging words in a text file
//precondition: pass in the vector of words (string) that make up the file
//postcondition: return the number of challenging words in the file (integer)
int difficultWords(vector <string> words)
{
	int difficultWords = 0;
        vector <string> wordList = createDaleChallList();
        for (int i = 0; i < words.size(); i++)
        {
        	bool found = binary_search(wordList.begin(), wordList.end(), words[i]);
                //if a word isn't found on the easy word list (Dale-Chall list), increment our difficultWords variable
		if (!found)
                {
			difficultWords++;
        	}
	}
        return difficultWords;
}

double fleschKincaidIndex(vector<string>words, int numSentences, int numWords)
{
        int totalSyll = totalSyllables(words);
        double a = ((double)totalSyll/(double)numWords);
        double b = ((double)numWords/(double)numSentences);

        double index = (a*11.8) + (b*0.39) - 15.59;
	return index;
}

int fleschIndex(vector<string>words, int numSentences, int numWords)
{
        int totalSyll = totalSyllables(words);

        double a = ((double)totalSyll/(double)numWords);
        double b = ((double)numWords/(double)numSentences);

        return round((206.835 - (a*84.6) - (b*1.015)));
}

double daleChallIndex(vector<string> words, int numSentences, int numWords)
{
   	int hardWords = difficultWords(words);
	double a = ((double)hardWords/(double)numWords);
        double b = ((double)numWords/(double)numSentences);
        double index = ((a*100)*0.1579)+(b*0.0496);
        if((a*100) > 5)
        	index += 3.6365;
        return round(index*10)/10;
}

