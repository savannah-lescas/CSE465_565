// Copyright 2024
// Savannah Lescas
#include <iostream>
#include <unordered_map>
#include <vector>
#include <fstream>
#include <sstream>
#include <regex>

using namespace std;

class Interpreter {

    public: 
        unordered_map<string, string> variables;
        int lineNumber = 0;

        bool isInt(string input) {
            regex pattern("-?(0|[1-9]\\d*)");

            return regex_match(input, pattern);
        }

        bool checkVarName(string varName) {
            regex pattern("^[a-zA-Z][\\w$]*$");

            return regex_match(varName, pattern);

        }


        string getRidOfQuotes(string quoted) {
            string noQuotes = "";
            for (size_t i = 0; i < quoted.length(); i++) {
                if (quoted[i] != '"') {
                    noQuotes += quoted[i];
                }
            }
            return noQuotes;
        }

        void print(string variableName) {
            auto search = variables.find(variableName);
            if (search != variables.end()) {
                cout << variableName << "=" << search->second << endl;
            } else {
                cout << "RUNTIME ERROR: line " << lineNumber << endl;
                exit(1);
            }
        }

        void initialize(string first, string second, string third, string fourth) {
            auto search = variables.find(third);
            if (search != variables.end()) {
                string value = search->second;
                variables[first] = value;
            } else {
                variables[first] = third;
                // idk maybe add some stuff here
            }
        }

        void compoundAssignments(string variableName, string op, string right) {
            auto search = variables.find(variableName);
            if (search != variables.end()) {
                string left = search->second;
                if (!isInt(left) && !isInt(right)) {
                    if (op == "+=") {
                        variables[variableName] = left + right;
                    }
                } else if (!isInt(left) && isInt(right)
                    || isInt(left) && !isInt(right)) {
                        cout << "RUNTIME ERROR: line " << lineNumber << endl;
                        exit(1);
                } else {
                    int leftInt = stoi(left);
                    int rightInt = stoi(right);
                    if (op == "+=") {
                        variables[variableName] = leftInt + rightInt;
                    } else if (op == "-=") {
                        variables[variableName] = leftInt - rightInt;
                    } else if (op == "*=") {
                        variables[variableName] = leftInt * rightInt;
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


        void instruction(vector<string> input) {
            if (input[1] == "=") {
                if (input.size() < 4 || input[2] == ";") {
                    cout << "RUNTIME ERROR: line " << lineNumber << endl;
                    exit(1);
                } else {
                    if (checkVarName(input[0])) {
                        initialize(input[0], input[1], input[2], input[3]);
                    } else {
                        cout << "RUNTIME ERROR: line " << lineNumber << endl;
                        exit(1);
                    }
                }
            } else {
                auto search = variables.find(input[2]);
                if (search != variables.end()) {
                    string value = search->second;
                    compoundAssignments(input[0], input[1], value);
                } else {
                    compoundAssignments(input[0], input[1], getRidOfQuotes(input[2]));
                }
            }
        }

        // still need to implement loop

        void doAssignments(vector<string> input) {
            string firstInstruction = input[0];

            if (firstInstruction == "FOR") {
                //loop(input);
            } else if (firstInstruction == "PRINT") {
                print(input[1]);
            } else {
                try {
                    instruction(input);
                } catch (...) {
                    cout << "Error" << endl;
                }
            }
        }

};

int main (int argc, char *argv[]) {
    string filename = "";
    if(argc == 2) {
        filename = argv[1];
    } else {
        cout << "Usage: ./Zpm filename.zpm" << endl;
        exit(1);
    }
    string extension = ".zpm";
    // making sure file ends with ".zpm"
    // compare code from geeksforgeeks.org
    if (filename.compare(filename.size() - extension.size(), extension.size(), extension) != 0) {
        cout << "File needs to have .zpm extension" << endl;
        exit(1);
    }

    ifstream inputFile(filename);
    if (!inputFile) {
        cout << "File could not be opened" << endl;
        exit(1);
    }

    unordered_map<string, string> variables;
    int lineNumber = 0;
    string line;
    vector<string> input;
    regex pattern("(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)\\s+");
    while (getline(inputFile, line)) {
        lineNumber++;
        string s;
        stringstream ss(line);
        while (getline(ss, s, ' ')) {
            input.push_back(s);
        }

        Interpreter interpreter;

        interpreter.doAssignments(input);
    }

    return (0);
}