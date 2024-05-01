// Copyright 2024
// Savannah Lescas
#include <iostream>
#include <unordered_map>
#include <vector>
#include <fstream>
#include <sstream>
#include <regex>

using namespace std;

typedef pair<string, string> stringPair;

string strip(string unStrippedString) {
    string strippedString = "";
    if (unStrippedString.size() >= 2 && unStrippedString.front() == '"' && unStrippedString.back() == '"') {
        strippedString = unStrippedString.substr(1, unStrippedString.size() - 2);
    } 
    return strippedString;
}
template<typename T>
class Interpreter {
    public:
        string filename;
        unordered_map<string, T> variables; // made need to make the type generic for var
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

        
        vector<stringPair> lexicalAnalysis(string line) {
            vector<stringPair> tokens;
            
            // ChatGPT for loop and tok_type/tok_regex
            for (const auto& pair : TOKEN_SPECIFICATION) { 
                const std::string& tok_type = pair.first;
                const std::string& tok_regex = pair.second;
                
                // keeps track of what has been read and what hasn't
                int pos = 0;

                // same as re.compile
                regex regex(tok_regex);

                while (pos < line.length()) {
                    // keeps track of the string to check
                    // with pos as the position that gets updated
                    // once something is read, the new string will
                    // not include what is already read
                    string substring = line.substr(pos);
                    // smatch holds information about the regex_search call
                    // can tell us about the substrings and positions
                    smatch match;
                    // using regex_search becasue regex_match gives true or false
                    // when we need actual information
                    if (regex_search(substring, match, regex)) { // ChatGpt for regex_search 
                        if (tok_type != "ws" && tok_type != "NEWLN") {
                            // retrieves the matches string
                            string matchedToken = match.str(0);
                            // adds the token type with the token to the token vector
                            tokens.push_back({tok_type, matchedToken});
                        }

                        // updates position 
                        pos += match.length();
                        
                        // this condition is to stop checking the rest of the line
                        // once we find either an integer variable or string variable
                        // and then , we start looking for the next pattern on the line
                        if (tok_type == "INT_VAR" || tok_type == "STR_VAR") {
                            break;
                        }
                    } else {
                        pos += 1;
                    }
                }

            }

            return tokens;
        }

        void parse(vector<stringPair> tokens) {
            vector<stringPair>::iterator it;

            for (it = tokens.begin(); it != tokens.end(); it++) {
                if (it->first == "INT_VAR" || it->second == "STR_VAR") {
                    string varName = it->second;
                    it++;
                    it++;
                    string opToken = it->second;
                    it++;
                    stringPair valueToken(it->first, it->second);
                    it++;
                    string semicolon = it->second;

                    auto value;
                    if (valueToken.first == "NUMBER") {
                        value = stoi(valueToken.second);
                    } else if (valueToken.first == "STRING") {
                        value = strip(valueToken.second);
                    } else {
                        value = variables[valueToken.first];
                    }

                    try {
                        if (opToken == "=") {
                            variables[varName] == value;
                        } else if (opToken == "+=") {
                            variables[varName] += value;
                        } else if (opToken == "-=") {
                            variables[varName] -= value;
                        } else if (opToken == "*="){
                            variables[varName] *= value;
                        }
                    } catch (...) {
                        cout << "Error in line: " << this.line_number << endl;
                        exit(1);
                    }
                }
            }


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