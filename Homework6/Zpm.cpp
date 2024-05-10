// Copyright 2024
// Savannah Lescas
#include <iostream>
#include <unordered_map>
#include <vector>
#include <fstream>
#include <sstream>
#include <regex>

using namespace std;

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

void stringCheck(vector<string>& input) {
    string newString = "";
    int index;
    auto search = variables.find(input[2]);
    if (!isInt(input[2]) && search == variables.end()) {
        for (size_t i = 2; i < input.size(); i++) {
            if (input[i][0] == '"') {
                index = i;
                newString += input[i] + " ";
                break;
            }
        }
        for (size_t i = index + 1; i < input.size(); i++) {
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
        newString += input[2];
    }
    input[2] = newString;
    input[3] = ";";
    while (input.size() > 4) {
        input.pop_back();
    }   
}


void instruction(vector<string>& input) {
    stringCheck(input);
    if (input[1] == "=") {
        // this checks that the line has at least 4 parts and that the
        // last part is a semicolon
        if (input.size() < 4 || !(input[input.size() - 1] == ";")) {
            cout << "first check RUNTIME ERROR: line " << lineNumber << endl;
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
            //cout << value << endl;
            compoundAssignments(input[0], input[1], value);
        } else {
            //compoundAssignments(input[0], input[1], getRidOfQuotes(input[2]));
            compoundAssignments(input[0], input[1], input[2]);
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



int main (int argc, char *argv[]) {
    string filename = "";
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

    ifstream inputFile(filename);
    if (!inputFile) {
        cout << "File could not be opened" << endl;
        exit(1);
    }

    string line;
    vector<string> input;
    while (!inputFile.eof()) {
        getline(inputFile, line);
        lineNumber++;
        if (line.empty()) {
            continue;
        }
        input.clear();
        string s;
        stringstream ss(line);
        while (getline(ss, s, ' ')) {
            input.push_back(s);
        }

        /*
        for (auto x : input) {
            cout << x << endl;
        }*/

        doAssignments(input);
    }

    return (0);
}