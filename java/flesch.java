//Emily Wilbourn
//Flesch program in Java
import java.io.*;
import java.util.*;
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
				words.add(fileInput);
		}	

		sc.close();
		return words;
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
		//return str.matches("[-+]?\\d+(\\.\\d+)?");
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
		BitSet vowel_positions = new BitSet (word.length());
		//loop that increments counter when the character is a digit
		for (int i = 0; i < word.length(); i++)
			if (isVowel(word.charAt(i)))
                  	      vowel_positions.set(i);
		return syllables;
	}	

	
	//method to count the total number of syllables in the text file
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
	//add method to determine the number of sentences in the file
	//a sentence is ended by a period, colon, semicolon, question mark, 
	//or exclamation mark
	

	//add method to determine the flesch index
	
	//add method to determine the flesch-kincaid index
	
	//add method to determine the dale-chall index
} 

