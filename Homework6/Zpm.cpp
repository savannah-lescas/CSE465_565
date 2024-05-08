// Copyright 2024
// Savannah Lescas
#include <iostream>
#include <unordered_map>
#include <vector>
#include <fstream>
#include <sstream>
#include <regex>

using namespace std;
template<typename T>

void doAssignments(vector<string> input) {
    string firstInstruction = input[0];

    if (firstInstruction == "FOR") {
        //loop(input);
    } else if (firstInstruction == "PRINT") {
        //print(input[1]);
    } else {
        try {
            //instruction(input);
        } catch (...) {
            cout << "Error" << endl;
        }
    }
}

void instruction(vector<string> input, unordered_map<string, string> variables, int lineNumber) {
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
        if (variables.find(input[2]) != variables.end()) {
            compoundAssignments(input[0], input[1], variables.find(input[2]));
        } else {
            compoundAssignments(input[0], input[1], getRidOfQuotes(input[2]));
        }
    }
}

void initialize(string first, string second, string third, string fourth, unordered_map<string, string> variables) {
    auto search = variables.find(third);
    if (search != variables.end()) {
        string value = search->second;
        variables[first] = value;
    } else {
        variables[first] = third;
        // idk maybe add some stuff here
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

    return (0);
}