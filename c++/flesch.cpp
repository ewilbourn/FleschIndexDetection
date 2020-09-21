#include <iostream>
#include <fstream>
#include <deque>
using namespace std;
void readFile(deque<string> &words, string input);
int main ()
{
	string input;
	cout << "Enter the name of the input file: ";
	cin >> input;

	deque<string> words(1);

	readFile(words, input);
	//for (int i = 1; i < words.size(); i++)
	//	cout << words[i] << endl;
	return 0;
}
void readFile(deque<string> &words, string input)
{
    ifstream file;
    file.open (input);
    if (!file.is_open()) return;

    string word;
    while (file >> word)
    {
        words.push_back(word);
    }
}
