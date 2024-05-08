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
unordered_map<string, T> variables;
int lineNumber = 0;

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

    return (0);
}