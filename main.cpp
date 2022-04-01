/*
Author:     Trent Hardy
Compiler:   GNU CC
Date:       09/06/2020

Purpose of program: Print shapes and designs to console using char variables.

The program assigns characters such as *, $, or even a empty space, to variables. It then uses the variables in cout statements
to generate a variety of patterns and shapes.
*/

//1.4 HW1
// CS 1336.006

#include <iostream>

using namespace std;

int main()
{
    // assign char variables
    char space = ' ';
    char symbolOne = '*';

    // cout out the * Pyramid
    cout << space << space << space << symbolOne << endl;
    cout << space << space << symbolOne << symbolOne << symbolOne << endl;
    cout << space << symbolOne << symbolOne << symbolOne << symbolOne << symbolOne << endl;
    cout << symbolOne << symbolOne << symbolOne << symbolOne << symbolOne << symbolOne << symbolOne << endl;
    // I would personally use a for loop for this, but the assignment specifies not to.

    cout << endl; // create space

    // cout the * rectangle
    cout << symbolOne << symbolOne << endl;
    cout << symbolOne << symbolOne << endl;
    cout << symbolOne << symbolOne << endl;

    cout << endl; // create space

    // cout the $ pyramid
    char symbolTwo = '$';
    cout << space << space << space  << symbolTwo << endl;
    cout << space << space << symbolTwo << symbolTwo << symbolTwo << endl;
    cout << space << symbolTwo << symbolTwo << symbolTwo << symbolTwo << symbolTwo << endl;
    cout << symbolTwo << symbolTwo << symbolTwo << symbolTwo << symbolTwo << symbolTwo << symbolTwo << endl;

    cout << endl; // create space

    // cout the $ rectangle
    cout << symbolTwo << symbolTwo << endl;
    cout << symbolTwo << symbolTwo << endl;
    cout << symbolTwo << symbolTwo << endl;





    return 0;
}
