// Copyright 2024
// Savannah Lescas
// => I'm competing for BONUS Points <=
#include <iostream>
#include <unordered_map>
#include <vector>
#include <fstream>
#include <sstream>
#include <regex>

using namespace std;

void doAssignments(vector<string> input);

// global variables that will be used throughout to store
// information
unordered_map<string, string> variables;
int lineNumber = 0;

/**
 * A method that checks if the input string is a number.
 * 
 * @param input A string to be checked/
 * @return bool true if the string is a number, false otherwise.
*/
bool isInt(string input) {
    regex pattern("-?(0|[1-9]\\d*)");

    return regex_match(input, pattern);
}

/**
 * A method that checks that the variable name is in the correct
 * format.
 * 
 * @param varName The string to be checked.
 * @return bool true if it follows the naming rules.
 */
bool checkVarName(string varName) {
    regex pattern("^[a-zA-Z][\\w]*$");

    return regex_match(varName, pattern);

}

/**
 * A method that gets rid of the quotes surrounding a string.
 * 
 * @param quoted A string with quotes.
 * @return string The string with the quotes removed.
 */
string getRidOfQuotes(string quoted) {
    string noQuotes = "";
    for (size_t i = 0; i < quoted.length(); i++) {
        if (quoted[i] != '"') {
            noQuotes += quoted[i];
        }
    }
    return noQuotes;
}

/**
 * A method that performs print statements.
 * 
 * @param variableName The string of a variable name that
 * will  be searched for in the variables map to find the
 * value of and print.
 */
void print(string variableName) {
    auto search = variables.find(variableName);
    if (search != variables.end()) {
        cout << variableName << "=" << search->second << endl;
    } else {
        // if the variable is not in the map then it is not assigned
        // to a value and cannot be printed
        cout << "RUNTIME ERROR: line " << lineNumber << endl;
        exit(1);
    }
}

/**
 * A method that does the initizalizing of the variables.
 * 
 * @param first Usually the variable name to assign something to.
 * @param second Usually the assignment operator.
 * @param third WHat the variable is being assigned to.
 * @param fourth Usuallt the semicolon.
 */
void initialize(string first, string second, string third, string fourth) {
    // checks if the variable is being assigned to another variable
    auto search = variables.find(third);
    if (search != variables.end()) {
        // if it is get that variable's value and assign the variable to it
        string value = search->second;
        variables[first] = value;
    } else {
        // otherwise create a new key value pair with the variable name as the 
        // key and the value on the right as the value
        variables[first] = third;
    }
}

/**
 * This method performs the compound assignments. Compound assignments are
 * +=, -=, and *=. += only works with string to string or int to int, and 
 * the rest are only int to int. Throw an error if not following the rules.
 * 
 * @param variableName The pre-existing variable from the map to be updated.
 * @param op The compound operator.
 * @param right What the pre-existing variable is being copounded with 
 */
void compoundAssignments(string variableName, string op, string right) {
    // making sure the variable does exist in the map
    auto search = variables.find(variableName);
    if (search != variables.end()) {
        // initializes the left side of the equation to be the variable's
        // value
        string left = getRidOfQuotes(search->second);
        // if what's on the left and what's on the right are both strings
        if (!isInt(left) && !isInt(right)) {
            // and the operator is +=
            if (op == "+=") {
                // update the variable value to the concatenated strings
                variables[variableName] = '"' + left + right + '"';
            }
        // if a string is being added to an int or vice versa, that is in
        // violation of the compound rules and will produce a runtime error
        } else if (!isInt(left) && isInt(right)
            || isInt(left) && !isInt(right)) {
                cout << "RUNTIME ERROR: line " << lineNumber << endl;
                exit(1);
        // otherwise both sides of the equations are integers and can do
        // any of the compound assignments
        } else {
            // turn them into integers
            int leftInt = stoi(left);
            int rightInt = stoi(right);
            if (op == "+=") {
                string total = to_string(leftInt + rightInt);
                variables[variableName] = total;
            } else if (op == "-=") {
                string total = to_string(leftInt - rightInt);
                variables[variableName] = total;
            } else if (op == "*=") {
                string total = to_string(leftInt * rightInt);
                variables[variableName] = total;
            } else {
                cout << "RUNTIME ERROR: line " << lineNumber << endl;
                exit(1);
            }

        }
    } else {
        cout << "RUNTIME ERROR: line " << lineNumber << endl;
        exit(1);
    }
}

/**
 * A method that figures out if the line from the file has a line separated by
 * spaces, if so it takes it from being split up to being one big string.
 * 
 * @param input The vector that holds the space separated line.
 */
void stringCheck(vector<string>& input) {
    string newString = "";
    auto search = variables.find(input[2]);
    // if the value is a string and does not exist in the map
    if (!isInt(input[2]) && search == variables.end()) {
        // a condition that checks if two elements from the input vector
        // next to each other are both quotes, if they are then that
        // means the variable was meant to be assigned as a space
        if (input.size() > 3) {
            if (input[2][0] == '"' && input[3][0] == '"') {
                newString += " ";
            }
        }
        // if it starts with a quote and does not end with 
        // a quote then it is part of a longer string
        if (input[2][0] == '"' && input[2].back() != '"') {
            // so add it to the new string and add a space
            newString += input[2] + " ";
            // get the rest of the longer string and add it to the newString
            for (size_t i = 3; i < input.size(); i++) {
                if (input[i] == ";") {
                    break;
                } else if (!(input[i].back() == '"')) {
                    newString += input[i] + " ";
                    continue;
                } else {
                    newString += input[i];
                    break;
                }
            }
        } else {
            // otherwise, the string is just one word and the 
            // space isn't necessary
            newString += input[2] + "";
        }
    } else {
        // it's just a number
        newString += input[2];
    }
    // updating the input vector
    input[2] = newString;
    if (input.size() >= 4) {
        input[3] = ";";
        while (input.size() > 4) {
            input.pop_back();
        }   
    } else {
        input.push_back(";");
    }
}

/**
 * A method that either goes and initilizes a variable or sends it off to
 * do its compound assignment based off of the operator.
 * 
 * @param input The vector that holds the tokens from the line.
 */
void instruction(vector<string>& input) {
    stringCheck(input);
    if (input[1] == "=") {
        // this checks that the line has at least 4 parts and that the
        // last part is a semicolon
        if (input.size() < 4 || !(input[input.size() - 1] == ";")) {
            cout << "first check RUNTIME ERROR: line " << lineNumber << endl;
            exit(1);
        } else {
            // if the variable name is good, call the initalize method to 
            // get it into the map
            if (checkVarName(input[0])) {
                initialize(input[0], input[1], input[2], input[3]);
            } else {
                cout << "RUNTIME ERROR: line " << lineNumber << endl;
                exit(1);
            }
        }
    } else {
        // if compounding a variable with an existing variable
        auto search = variables.find(input[2]);
        if (search != variables.end()) {
            // get the value of the variable
            string value = search->second;
            compoundAssignments(input[0], input[1], getRidOfQuotes(value));
        } else {
            compoundAssignments(input[0], input[1], getRidOfQuotes(input[2]));
        }
    }
}

/**
 * A method that performs a for loop. Get's the number of iterations
 * then the statements to perform, then runs it.
 * 
 * @param input The vector with the parts of the line.
 */
void loop(vector<string> input) {
    // gets the iterations by the int or the int stored in the map
    int iterations;
    auto search = variables.find(input[1]);
    if (search != variables.end()){
        iterations = stoi(search->second);
    } else {
        iterations = stoi(input[1]);
    }

    // set up a vector to hold to statements
    vector<string> statements = {};
    string statement = "";
    // starting at the first part of the line
    for (int i = 2; i < input.size(); i++) {
        if (input[i] == "ENDFOR") {
            // once reaching the end of the line, do what's
            // what's inside the line for the number of iterations
            for (int j = 0; j < iterations; j++) {
                // run each statement
                for (int k = 0; k < statements.size(); k++) {
                    vector<string> instruction;
                    string s;
                    stringstream ss(statements[k]);
                    while (getline(ss, s, ' ')) {
                        instruction.push_back(s);
                    }
                    doAssignments(instruction);
                }
            }
        // add to the statement string if not a semicolom
        } else if (input[i] != ";") {
            statement += input[i] + " ";
        // once input[i] has reached a semicolon, we know the statement is
        // done, so add it to the vector and empty the statement string
        } else {
            statements.push_back(statement);
            statement = "";
        }
    }
}

/**
 * A method that calls the respective method based on the first
 * part of the line.
 * 
 * @param input The vector that holds the parts of the line.
 */
void doAssignments(vector<string> input) {
    // first part of the line
    string firstInstruction = input[0];

    if (firstInstruction == "FOR") {
        loop(input);
    } else if (firstInstruction == "PRINT") {
        print(input[1]);
    } else {
        try {
            // if not FOR or PRINT it is something to do with a
            // variable
            instruction(input);
        } catch (...) {
            cout << "Error" << endl;
        }
    }
}



int main (int argc, char *argv[]) {
    string filename = "";
    // makes sure there are 2 inputs with the second being the filename
    if(argc == 2) {
        filename = argv[1];
    } else {
        cout << "Usage: ./Zpm filename.zpm" << endl;
        exit(1);
    }

    regex regex(".*\\.zpm");
    // making sure file ends with ".zpm"
    if (!regex_match(filename, regex)) {
        cout << "File needs to have .zpm extension" << endl;
        exit(1);
    }

    // making sure the file can be opened
    ifstream inputFile(filename);
    if (!inputFile) {
        cout << "File could not be opened" << endl;
        exit(1);
    }

    string line;
    vector<string> input;
    // reads through the file
    while (!inputFile.eof()) {
        getline(inputFile, line);
        lineNumber++;
        if (line.empty()) {
            continue;
        }
        input.clear();
        string s;
        stringstream ss(line);
        // separates the line by spaces
        while (getline(ss, s, ' ')) {
            input.push_back(s);
        }
        // calles doAssignments on the vector of strings of the line
        doAssignments(input);
    }

    return (0);
}