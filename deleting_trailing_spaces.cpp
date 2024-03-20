#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main() {
    ifstream inputFile("input.txt");
    ofstream tempFile("temp.txt");

    if (!inputFile.is_open()) {
        cerr << "Error opening input file." << endl;
        return 1;
    }

    if (!tempFile.is_open()) {
        cerr << "Error creating temporary file." << endl;
        inputFile.close();
        return 1;
    }

    string line;
    while (getline(inputFile, line)) {
        size_t pos = line.find_last_not_of(" \t");
        if (pos != string::npos) {
            line = line.substr(0, pos + 1);
        } else {
            line.clear(); // Handle if the line contains only spaces
        }
        tempFile << line << endl;
    }

    inputFile.close();
    tempFile.close();

    if (rename("temp.txt", "input.txt") != 0) {
        cerr << "Error replacing file." << endl;
        return 1;
    }
    
    return 0;
}