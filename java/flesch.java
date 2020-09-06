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
        		words.add(sc.next());	
		}

		sc.close();
		return words;
	}

}

