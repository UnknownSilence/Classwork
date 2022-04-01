//Title: CS1337 Assignment 6
//Program: Recursion
//Course: CS 1337.009
//Instructor: John Cole

/******************************************************************************
 * Recursive palindromes
 * Author: Trent Hardy
 * Date: 4/20/2021
 *
 * Use a Recursive functions to call themselves.
 *
 * Write a recursive function that determines if an input string is a palindrome.
 *
 * Rules:
 * 1.) Punctuation and spaces don't count
 * 2.) Only digits and letters should be considered
 * 3.) Capital letters and lower case letters must be treated as the same
 * 4.) Digits are allowed
 *
 *
 *
 * Palindrome Definition: A word, phrase, or sequence that can be read the same backwards as forward
 *
 *
 *
 *
 * String class will be used for input parameter.
 *
 * Function declaration is: bool isPalindrome(string);
 *
 * Function takes exactly ONE parameter. No more than that.
 *
 * The driver program should ask for a string, display the string, and output whether it is a palindrome or not. It should continue to do this in a loop until
 * the character (*) is entered.
 *
 * Written by Trent Hardy (tth190003) at The University of Texas at Dallas
 * Major: Computer Science (B.S.)
 * Started Monday, April 19, 2021
 * Finished Thursday, April 22, 2021
 ******************************************************************************/


#include <iostream>
#include <fstream>
#include <Bits.h>
#include <string>
#include <ios>
#include <ostream>



using namespace std;

class Person {
public:
    char personName[20]; // 20 char max
    double personSalary; // salary value
    int personCounter; // binary num
    void mutatePersonData(int indexNum, double salaryValue, char personNameValue[]);
};




/*
void Person::mutatePersonData(int indexNum, double salaryValue, char personNameValue[])
{
    // code to update and modify
    // the content of the binary file
    int pos, flag = 0;

    // rno=9
    fstream fs;
    fs.open("Names.dat",
        ios::in | ios::binary | ios::out);

    while (!fs.eof()) {
        // storing the position of
        // current file pointeri.e. at
        // the end of previously read record
        pos = fs.tellg();

        fs.read((char*)this, sizeof(Person));
        if (fs) {

            // comparing the roll no with that
            // of the entered roll number
            if (rno == roll) {
                flag = 1;

                // setting the new (modified )
                // data of the object or new record
                getdata(r, str);

                // placing the put(writing) pointer
                // at the starting of the record
                fs.seekp(pos);

                // writing the object to the file
                fs.write((char*)this, sizeof(abc));

                // display the data
                putdata();
                break;
            }
        }
    }
    fs.close();

    if (flag == 1)
        cout << "\nrecord successfully modified \n";
    else
        cout << "\nrecord not found \n";
}
*/



// Sample input 1
/*
void Person::addNameRecord()
{
    int rno, r;
    char persName[20];

    // roll no to be searched
    rno = 1;

    // new roll no
    r = 11;

    // new name
    strcpy(name, "Geek");

    // call update function with new values
    mutatePersonData(rno, r, name);
}
*/

string convertToString(char* a, int size)
{
    int iteration;
    string asString = "";
    for (iteration = 0; iteration < size; iteration++) {
        asString = asString + a[iteration];
    }
    return asString;
}


int main()
{
    fstream file;
    file.open("Names.dat", ios::in | ios::binary | ios::out);

    cout << "Original Values" << endl << endl;

    while (!file.eof())
    {
        Person person;
        file.read(reinterpret_cast<char*>(&person.personName), sizeof(person.personName));
        cout << convertToString(person.personName, sizeof(person.personName)) << endl;
        file.read(reinterpret_cast<char*>(&person.personSalary), sizeof(person.personSalary));
        char salPosition = file.tellp();
        cout << person.personSalary << endl;
        person.personSalary += 100;
        file.read(reinterpret_cast<char*>(&person.personCounter), sizeof(person.personCounter));
        char counterPosition = file.tellp();
        cout << person.personCounter << endl;
        file.seekp(salPosition, ios::beg);
        file.write(reinterpret_cast<char*>(&person.personSalary), sizeof(person.personSalary));
        file.seekp(counterPosition, ios::beg);

    }

    file.clear();
    file.seekg(0);

    cout << endl << "After mutation" << endl << endl;

        while (!file.eof())
    {
        Person person;
        file.read(reinterpret_cast<char*>(&person.personName), sizeof(person.personName));
        cout << convertToString(person.personName, sizeof(person.personName)) << endl;
        file.read(reinterpret_cast<char*>(&person.personSalary), sizeof(person.personSalary));
        char salPosition = file.tellp();
        cout << person.personSalary << endl;
        file.read(reinterpret_cast<char*>(&person.personCounter), sizeof(person.personCounter));
        cout << person.personCounter << endl;

    }


    char myName[20] = "Trent\n";




    file.clear();
    file.close();






}
