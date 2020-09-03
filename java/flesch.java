//Emily Wilbourn
//Flesch program in Java
import java.io.*;
import java.util.*;
public class flesch
{
	public static void main(String[] args) throws IOException
	{
		Scanner in = new Scanner (System.in);
		System.out.print("Enter the name of the input file: ");
		

		//read in input from the user; this is reading in the input file
		String inputFile = in.nextLine();

		readFiles(inputFile);	
	}	

	
	//precondition: reads in a String value, which is the name of the file
	//we're reading in
	//
	//postcondition: the contents of the file we passed in are printed to the
	//screen
	public static void readFiles(String input) throws FileNotFoundException
	{
        	Scanner sc = new Scanner(new File(input));
        	System.out.println("Hello.");
		while (sc.hasNextLine())
        	{
                	System.out.println("I am in the while loop.");
			System.out.println(sc.nextLine());
        	}
		sc.close();
		System.out.println("Bye.");
	}

}

