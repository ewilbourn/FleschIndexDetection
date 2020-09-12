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
		words = findWords(words, inputFile);
		System.out.println(words.size());
		for (int i = 0; i < words.size(); i++)
		{
			System.out.println(words.get(i));
		}	
	}	

	
	//precondition: reads in an ArrayList of Strings, which we will be modifying
	//and returning, and a String value, which is the name of the file
	//we're reading in
	//
	//postcondition: the contents of the file we passed in are added to an 
	//ArrayList, which is returned
	public static ArrayList<String> findWords(ArrayList<String> words, String input) throws IOException
	{
        	Scanner sc = new Scanner(new File(input));
		while(sc.hasNext())
        	{
			//if the word, sc.next(), is not a number, add it to the ArrayList
			if(!isNumber(sc.next()))
			{
				words.add(sc.next());
			}	
	}	

		sc.close();
		return words;
	}
	
	//add method to determine if a char is a vowel
	

	//method to determine if a word is actually a number
	//precondition: passes in a string
	//postcondition: returns a boolean that tells us if the string is a number
	static boolean isNumber(String str)
	{	
		int counter = 0;
		
		//loop that increments counter when the character is a digit
		for (int i = 0; i < str.length(); i++)
			if (Character.isDigit(str.charAt(i)) == true)
				counter += 1;
		//if counter equals str.lenght(), it means that every char in the 
		//string is a digit, which means that we have a number
		return (counter == str.length() ? true : false); 
	}	

	//add method to determine how many syllables a word has (will need to call vowel method)
	//probably need to look at each word and then see where the vowels are and count the number of vowels? 
	//but if vowels are next to each other, they don't make up two different syllables
	
} 

