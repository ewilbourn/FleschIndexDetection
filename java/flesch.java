//Emily Wilbourn
//Flesch program in Java
import java.io.*;
import java.util.*;
import java.lang.Math;
public class flesch
{
	public static void main(String[] args) throws IOException
	{
		Scanner in = new Scanner (System.in);
		File directoryPath = new File("/pub/pounds/CSC330/translations");
		System.out.print("Enter the name of the input file: ");
	
		//read in input from the user; this is reading in the input file
		String inputFile = in.nextLine();
		ArrayList <String> words = new ArrayList <String>();
		words = findWords(words,inputFile);
		ArrayList <String> hard = createDaleChallList();		
		int numSent = countSentences(words);

		//initialize a new ArrayList<String> with the words that have the punctuation removed 
		ArrayList<String> newWords = removePunctuation(words);
	
		//for (int i = 0; i < newWords.size(); i++)
		//{		
		//	System.out.println(newWords.get(i));
		//}	
		int numSyll = totalSyllables(words);
		int numWords = totalWords(words);
		int hardWords = challengingWords(newWords);
		System.out.println("Sentences: " + numSent + "\nSyllables: " + numSyll + "\nWords: " + numWords + "\nDifficult Words: " + hardWords);	
		int flesch = fleschIndex(words);
		double flesch_kincaid = fleschKincaidIndex(words);
		double dale_chall = daleChallIndex(words, newWords);
		System.out.println("Flesch Readability Index: " + flesch + "\nFlesch-Kincaid Grade Level Index: " + flesch_kincaid + "\nDale-Chall Readability Score: " + dale_chall);
	}	

	
	
	//precondition: reads in an ArrayList of Strings, which we will be modifying
	//and returning, and a String value, which is the name of the file
	//we're reading in
	//
	//postcondition: the contents of the file we passed in are added to an 
	//ArrayList, which is returned
	public static ArrayList<String> findWords(ArrayList <String> words, String input) throws IOException
	{
        	Scanner sc = new Scanner(new File(input));
		
		while(sc.hasNext())
        	{
			String fileInput = sc.next();
			//if the word, sc.next(), is not a number, add it to the ArrayList
			if(!isNumber(fileInput))
				words.add(fileInput.toLowerCase());
		}	

		sc.close();
		return words;
	}
	
	public static ArrayList<String> removePunctuation(ArrayList <String> words)
	{
		ArrayList<String> newWords = new ArrayList<String>();
		for(int i = 0; i < words.size(); i++)
                {
			String word1 = words.get(i);
                        String word = words.get(i);
                	for (int j = 0; j < word.length(); j++)
                	{
                		if (isPunctuation(word.charAt(j)) || isOtherPunct(word.charAt(j)))
				{	
					String letter = Character.toString(word.charAt(j));
					word1 = word.replace(letter, "");
				}
			}
                	newWords.add(word1);
                }
		return newWords;

	}


	public static boolean isOtherPunct(char c)
	{
		char [] otherpunct = {'[', ']', '$', ','};
		for(int i = 0; i < otherpunct.length; i++)
		{
			if (Character.compare(c, otherpunct[i]) == 0)
				return true;
			if((Character.toString(c)).equals("'"))
				return true;
		}
		return false;

	}
	
	//method to determine if a char is a vowel
	//precondition: passes in a character
	//postcondition: returns a boolean that tells us if the char is a vowel
	public static boolean isVowel(char c)
	{
		char [] vowels = {'a', 'e', 'i', 'o', 'u','y'};
		for(char vowel:vowels)
		{
			if (Character.compare(Character.toLowerCase(c), vowel) == 0)
				return true;
		}
		return false;
	}	

	//method to determine if a word is actually a number
	//precondition: passes in a string
	//postcondition: returns a boolean that tells us if the string is a number
	public static boolean isNumber(String str)
	{	
		int counter = 0;
		
		//loop that increments counter when the character is a digit
		for (int i = 0; i < str.length(); i++)
			if (Character.isDigit(str.charAt(i)) == true)
				counter += 1;
		
		//if counter equals str.length(), it means that every char in the 
		//string is a digit, which means that we have a number
		return (counter == str.length() ? true : false); 
	}	

	//add method to determine how many syllables a word has (will need to call vowel method)
	//probably need to look at each word and then see where the vowels are and count the number of vowels? 
	//but if vowels are next to each other, they don't make up two different syllables
	public static int numSyllables(String word)
	{
		int syllables = 0;
		char[] charArray = new char[word.length()];
			
		//loop that add alls chars in a word to an array
		for (int i = 0; i < word.length(); i++)
			charArray[i] = word.charAt(i);
		
		//iterate through the chars in the array of letters
		for (int i = 0; i < charArray.length; i++)
		{
			if(!((i+1) == charArray.length && Character.toLowerCase(charArray[i]) == 'e'))
			{
				if(isVowel(charArray[i]))
				{
					syllables++;
					if ((i+1)< word.length() && isVowel(charArray[i+1]))
						i++;
				}
			}
		}
		if (syllables == 0)
			syllables = 1;
		return syllables;
	}	

	
	//method to count the total number of syllables in the text file
	//precondition: pass in the ArrayList of words
	//postcondition: return an integer with the number of syllables in the ArrayList
	public static int totalSyllables(ArrayList <String> words)
	{
		int syllables = 0;
		for(int i = 0; i < words.size(); i++)
		{
			syllables += numSyllables(words.get(i));
		}
		return syllables;
	}

	//method to count the total number of words in the text file
	//precondition: take in an ArrayList with all the words in the files
	//postcondition: return the number of words in the text file (aka the size of the ArrayList)
	public static int totalWords(ArrayList<String> words)
	{
		return words.size();
	}
	//method to count the total number of sentences in a text file
	//precondition: passes in an ArrayList of Strings that has all the words from the file
	//postcondition: returns an integer with the number of sentences
	public static int countSentences(ArrayList<String> words)
	{
		int numSentences = 0;
	
		for (int i = 0; i < words.size(); i++)
		{
			if(findSentence(words.get(i)))
				numSentences += 1;
		}
		return numSentences;
	}
	//method to determine if a word contains punctuation, and then represents
	//the end of a sentence in the file
	//precondition: passes in a string
	//postcondition: returns a boolean (true if the word has punctuation, false if it
	//does not
	public static boolean findSentence (String word)
	{
		List<Character> chars = new ArrayList<Character>();	
		for (int i = 0; i < word.length(); i++)
		{
			chars.add(word.charAt(i));	
		}
		for (int i = 0; i < chars.size(); i++)
		{
			if(isPunctuation(chars.get(i)))
				return true;
		}
		return false;
	}
	
	//method that determines if a character is punctuation
	//precondition: passes in a character c
	//postcondition: returns true (if it's punctuation that I've defined) or false
	public static boolean isPunctuation (char c)
	{
		char [] punctuation = {'.', ':', ';', '?', '!'};
                for(char p:punctuation)
                {
                        if (Character.compare(c, p) == 0)
                                return true;
                }
		return false;
	}
	//add method to determine the flesch index
	//precondition: pass in the arraylist of words
	//postcondition: return the flesch readability index as an integer
	public static int fleschIndex(ArrayList<String>words)	
	{
		int numSentences = countSentences(words);
                int numWords = totalWords (words);
                int totalSyll = totalSyllables(words);
	
		double a = ((double)totalSyll/(double)numWords);
		double b = ((double)numWords/(double)numSentences);

		return (int)(Math.round((206.835 - (a*84.6) - (b*1.015))*10)/10.0);
	}
	
	//add method to determine the flesch-kincaid index
	public static double fleschKincaidIndex(ArrayList<String>words)
	{
		int numSentences = countSentences(words);
                int numWords = totalWords (words);
                int totalSyll = totalSyllables(words);
		double a = ((double)totalSyll/(double)numWords);
                double b = ((double)numWords/(double)numSentences);
		
		double index = (a*11.8) + (b*0.39) - 15.59;
	        return (Math.round(index*10)/10.0);
		//return index;	
	}
		
	//add method to determine the dale-chall index
	public static double daleChallIndex(ArrayList<String> words, ArrayList<String> newWords)throws IOException
	{
		
		int numSentences = countSentences(words);
                int numWords = totalWords (words);
                int difficultWords =  challengingWords(newWords);
                double a = ((double)difficultWords/(double)numWords);
                double b = ((double)numWords/(double)numSentences);
		double index = ((a*100)*0.1579)+(b*0.0496);
		if(a < 0.05)
			index += 3.6365;
		return (Math.round(index*10)/10.0);
		//return index;
	}

	//method to perform a binary search
	//precondition: pass in the arraylist of strings and the string key we're looking for
	//postcondition: return the location of the key in the arraylist; if the key isn't found, then return -1
	private static int binarySearch (ArrayList <String> wordList, String key)
	{
		int first = 0, last = (wordList.size()-1), middle, location;
		boolean found = false;

		do
		{
			middle = (first + last) / 2;
			if (key.equals(wordList.get(middle)))
				found = true;
			else if (key.compareTo(wordList.get(middle))<0)
				last = middle - 1;

			else
				first = middle + 1;
		}while ((! found) && (first <= last));

		location = middle;

		return (found ? location : -1);
	}
	
	//method to count the number of words in a text file that are considered difficult
	//precondition: pass in the arraylist of words from the text file we're reading in
	//postcondition: return the integer with the number of difficult words in the text file
	private static int challengingWords(ArrayList <String> words)throws IOException
	{
		int difficultWords = 0;
		ArrayList <String> wordList = createDaleChallList();
		for (int i = 0; i < words.size(); i++)
		{
			//perform a binary search to tell if a word is in the dale-chall list (list of easy words)
			int found = binarySearch(wordList, words.get(i));
			
			//if the word is not found in the easy word list, increment the difficultWords variable
			if (found == -1)
			{
				difficultWords++;
			//	System.out.println(words.get(i) + " not found.");
			}
		}	
		return difficultWords;
		
	}

	//method to create an ArrayList of Strings for the DaleChallList
	//precondition: takes in no arguments
	//postcondition: returns the arraylist of strings that holds all the words from the dale chall list	
	private static ArrayList<String> createDaleChallList() throws IOException
	{
		ArrayList<String> daleChall = new ArrayList<String>();
		daleChall = findWords(daleChall, "/pub/pounds/CSC330/dalechall/wordlist1995.txt");
	//	Collections.sort(daleChall);
		selectionSort(daleChall);
		return daleChall;
	}

	//method to sort a given ArrayList<String>
	private static void selectionSort(ArrayList<String>words)
	{
		int minIndex;
		String temp;

		for (int i = 0; i < words.size(); i++)
		{
			minIndex = i;
			for(int j = minIndex+1; j < words.size(); j++)
				if(words.get(j).compareTo(words.get(minIndex)) < 0)
					minIndex = j;
			//swap algorithm
			if (minIndex != i)
			{	
				temp = words.get(i);
				words.set(i, words.get(minIndex));
				words.set(minIndex, temp);
			}		
		}
	}

} 

