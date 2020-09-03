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
		String inputFile = in.nextLine();
		//System.out.print(inputFile);
		readFiles(inputFile);	
	}	

	public static void readFiles(String input) throws FileNotFoundException
	{
        	Scanner in = new Scanner(new File(input));
        	System.out.println("Hello.");
		while (in.hasNextLine())
        	{
                	System.out.println("I am in the while loop.");
			System.out.println(in.nextLine());
        	}
		System.out.println("Bye.");
	}

}

