/**
 * Savannah Lescas
 * Dr. Amjad
 * Comparative Programming Languages
 * 8 February 2024
 * A program that takes in a .zpm file from the command line. In the .zpm file
 * there are Z+- commands. The program takes the commands from the file 
 * and processes/interprets them. 
 */

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;

public class Zpm {
	
	private static HashMap<String, Object> variables = new HashMap<>();
	private static int lineNumber = 0;
	
	public static void main(String[] args){
		// check if a filename is one of the arguments
		if (args.length == 0)  {
			System.out.println("Usage: java Zpm filename.zpm");
			System.exit(1);
		}
		String filename = args[0];
		// make sure that it is a .zpm extension
		if (!filename.endsWith(".zpm")) {
			System.out.println("File needs to have .zpm extension");
			System.exit(1);
		}
		File file = new File(filename);
		try (Scanner scan = new Scanner(file)) {
			// traverse the file
			while (scan.hasNextLine()) {
				String line = scan.nextLine();
				// split the parts of the line into strings
				String[] input = line.split(" ");
				lineNumber++;
				// run it through the doAssignments method
				doAssignments(input);
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	/*
	 * A method that gets the first part of the line to determine what it
	 * is trying to do.
	 */
	public static void doAssignments(String[] input) {
		String firstInstruction = input[0];
		// switch case with the first instruction
		switch (firstInstruction) {
			// if the instruction is FOR do the for loop method
			case "FOR":
				loop(input);
				break;
			// if the instruction is PRINT run the print method
			case "PRINT":
				// use the print function to print
				print(input[1]);
				break;
			// if it is not FOR or PRINT it is either a variable assignment
			// or a compound assignment
			default:
			try {
				instruction(input);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	/*
	 * A method that checks if the line is a variable assignment or a 
	 * compound assignment and does the instruction respectively.
	 */
	public static void instruction(String[] input) {
		// if the second part of the input line is just "=" that means 
		// it is a variable assignment
		if (input[1].equals("=")) {
			// makes sure the line is correctly syntaxed
			if (input.length < 4 || input[2].equals(";")) {
				System.out.println("RUNTIME ERROR: line " + lineNumber);
				System.exit(1);
			} else {
				// check that the variable name has no numbers
				if (checkVarName(input[0])) {
					// if it is all good initialize it and put it into the hash map
					initialize(input[0], input[1], input[2], input[3]);
				} else {
					System.out.println("RUNTIME ERROR: line " + lineNumber);
					System.exit(1);
				}
			}
		// if the second part of the input is not "=", it is a compound assignment
		} else {
			// if the right side of the compound assignment is a variable name,
			// do the assignment with the value from the variable key
			if (variables.containsKey(input[2])) {
				compoundAssignments(input[0], input[1], variables.get(input[2]));
			// if it is not a variable then do the compound assignment regularly
			} else {
				compoundAssignments(input[0], input[1], input[2]);
			}
		}
	}
	
	/*
	 * A method that does the variable initialization. If the variable does not
	 * already exist in the hash map, add it to the map. If the variable is 
	 * getting assigned to another variable's value change the variable's value.
	 */
	public static void initialize(String first, String second,
			String third, String fourth) {
		// if the assignment is to a variable that exists, assign the
		// variable to the value of the other variable
		if (variables.containsKey(third)) {
			Object value = variables.get(third);
			variables.put(first, value);
		} else {
			// create a new key value pair and put it into the hash map
			try {
				Integer intObj = Integer.parseInt(third);
				variables.put(first, intObj);
			} catch (NumberFormatException e) {
				// checking that the assignment is to a string not a non-initialized
				// variable
				if (third.length() >= 2 && third.charAt(0) == '"') {
					String noQuotes = third.substring(1, (third.length() - 1));
					variables.put(first, noQuotes);
				} else {
					// since we know that the length is too short and it isn't
					// any empty string we know that the file is trying to assign
					// a variable to a variable that does not have values so we
					// give a runtime error
					System.out.println("RUNTIME ERROR: line " + lineNumber);
					System.exit(1);
					
				}
			}
		}
	}
	
	/*
	 * A method that does the compound assignments. 
	 */
	public static void compoundAssignments(String variableName,
			String operator, Object right) {
		// checks if the variable has been initialized yet
		if (variables.get(variableName) != null) {
			String left = variables.get(variableName).toString();
			// if both sides are strings concatenate them
			if (!isInt(left) && !isInt(right.toString())) {
				if (operator.equals("+=")) {
					variables.put(variableName, String.valueOf(left) + String.valueOf(right));
				}
			// if the command is trying to add a string with an int
			// it will be a runtime error
			} else if (!isInt(left) && isInt(right.toString())
					|| isInt(left) && !isInt(right.toString())) {
				System.out.println("RUNTIME ERROR: line " + lineNumber);
				System.exit(1);
			// if the compound assignment is with two integers, do the assignment
			// and update the value in the map
			} else {
				int leftInt = Integer.parseInt(left);
				int rightInt = Integer.parseInt(right.toString());
				// figure out which compound assignment it is doing
				if (operator.equals("+=")) {
					variables.put(variableName, leftInt + rightInt);
				} else if (operator.equals("*=")) {
					variables.put(variableName, leftInt * rightInt);
				} else if (operator.equals("-=")) {
					variables.put(variableName, leftInt - rightInt);
				} else {
					System.out.println("RUNTIME ERROR: line " + lineNumber);
					System.exit(1);
				}
			}
		// if the variable is not initialized already, give a runtime error
		} else {
			System.out.println("RUNTIME ERROR: line " + lineNumber);
			System.exit(1);
		}
	}
	
	/*
	 * A method that prints the variable if it exists.
	 */
	public static void print(String variableName) {
		if (variables.get(variableName) != null) {
			System.out.println(variableName + "=" + variables.get(variableName));
		} else {
			System.out.println("RUNTIME ERROR: line " + lineNumber);
			System.exit(1);
		}
		
	}
	
	/*
	 * A method that performs the for loop. 
	 */
	public static void loop(String[] input) {
		// change the iterations string into an int
		int iterations = Integer.parseInt(input[1]);
		// an array list to hold the statements as if they were on their
		// own line
		ArrayList<String> statements = new ArrayList<String>();
		String statement = "";
		for (int i = 2; i < input.length; i++) {
			if (input[i].trim().equals("ENDFOR")){
				// use the iterations from the line to determine how many times
				// to do the loop
				for (int j = 0; j < iterations; j++) {
					// another loop to go through the array list that has each line
					// to repeat
					for (int k = 0; k < statements.size(); k++) {
						// take each task and separate it so the doAssignments method
						// can do the line
						String[] instruction = statements.get(k).split(" ");
						doAssignments(instruction);
					}
				}
			} else if (!input[i].equals(";")) {
				statement += input[i] + " ";
			} else {
				statements.add(statement);
				statement = "";
			}
		}
	}
	
	/*
	 * A method that checks to make sure the variable name the file is
	 * trying to use only letters.
	 * Returns true if the name is only letters and false otherwise.
	 */
	private static boolean checkVarName(String varName) {
		for (int i = 0; i < varName.length(); i++) {
			if (!(varName.charAt(i) >= 'A' && varName.charAt(i) <= 'Z') 
					|| varName.length() > 1) {
				return false;
			}
		}
		return true;
	}
	
	/*
	 * A method that checks if the input is an int.
	 */
	private static boolean isInt(String input) {
		//returns true if everything in string is a number
		return input.trim().matches("-?(0|[1-9]\\d*)");
	}
 }
