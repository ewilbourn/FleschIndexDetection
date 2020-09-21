#include <iostream>
#include <fstream>
#include <deque>
#include <stdio.h>
#include <ctype.h>

using namespace std;
void getWords(deque<string> &words, string input);
bool isNumber(string str);

int main ()
{
	string input;
	cout << "Enter the name of the input file: ";
	cin >> input;

	deque<string> words(1);

	getWords(words, input);
	for (int i = 1; i < words.size(); i++)
		cout << words[i] << endl;
	return 0;
}
void getWords(deque<string> &words, string input)
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
