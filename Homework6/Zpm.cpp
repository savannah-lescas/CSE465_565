// Copyright 2024
// Savannah Lescas
#include <iostream>
#include <unordered_map>
#include <vector>
#include <fstream>
#include <sstream>

using namespace std;

typedef pair<string, string> stringPair;
typedef unordered_map<string, string> dictionary;

class Interpreter {
    public:
        string filename;
        dictionary variables; // made need to make the type generic for var
        int lineNumber = 0;

        // Define the token specification
         vector<stringPair> TOKEN_SPECIFICATION = {
            {"INT_VAR",     "[a-zA-Z_][a-zA-Z_0-9]*\\s"},                   // Integer variable (lookahead for assignment and operations)
            {"STR_VAR",     "[a-zA-Z_][a-zA-Z_0-9]*\\s"},                   // String variable (lookahead for assignment and addition)
            {"ASSIGN",      "(?<=\\s)\\=(?=\\s)"},                           // Assignment operator
            {"PLUS_ASSIGN", "(?<=\\s)\\+=(?=\\s)"},                          // Addition assignment operator
            {"MINUS_ASSIGN","(?<=\\s)-=(?=\\s)"},                            // Subtraction assignment operator
            {"MULT_ASSIGN", "(?<=\\s)\\*=(?=\\s)"},                          // Multiplication assignment operator
            {"INT_VAR_VAL", "(?<=\\+=|-=|\\*=)\\s[a-zA-Z_][a-zA-Z_0-9]*"},    // Integer variable (lookahead for assignment and operations)
            {"STR_VAR_VAL", "(?<=\\+=)\\s[a-zA-Z_][a-zA-Z_0-9]*"},           // String variable (lookahead for assignment and addition)
            {"NUMBER",      "(?<=\\s)-?\\d+(?=\\s)"},                         // Integer literal
            {"STRING",      "\"[^\"]*\""},                                   // String literal, handling quotes
            {"SEMICOLON",   "(?<=\\s);"},                                    // Statement terminator
            {"WS",          "\\s+"},                                        // Whitespace
            {"NEWLN",       "\\n"}
        };

        Interpreter(string file_name) {
            filename = file_name;
            variables = {};
            lineNumber = 0;
        }

};

//template<typename Value>
//unordered_map<string, Value> assignments;
int lineNumber = 0;



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
    
    Interpreter interpreter(filename);

    return (0);
}