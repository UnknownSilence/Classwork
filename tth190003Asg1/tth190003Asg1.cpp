//Title: CS1337 Assignment 1
//Program: Obtain the sum of a simple series from given user input.
//Course: CS 1337.009
//Instructor: John Cole

/******************************************************************************
 * Sum of a Series Program
 * Author: Trent Hardy
 * Date: 1/28/2021
 *
 * The program requests an integer greater than 1.  If zero is entered, the program stops.
 * If a number equal to 1 or less than 0 is entered, the program should give an error and return to request another number.
 * The same is true for entering anything other than a number.
 * Your program should not crash or do strange things if you enter the letter A when it asks for a number.
 * It should simply print a message, then return to ask for a number.
 *
 * If the number entered is N, sum the series 1/N + 2/(N-1) + 3/(N-2)+ … +N/1.  Display the original number and the sum.
 *
 * Return to request another number.
 *
 * Objective: Demonstrate knowledge of loops, conditionals, and computation in C++
 *
 * Written by Trent Hardy (tth190003) at The University of Texas at Dallas
 * Major: Computer Science (B.S.)
 * Started Tuesday, January 26, 2021
 * Finished Thursday, January 28, 2021
 ******************************************************************************/

#include <iostream>
#include <string>

using namespace std;

// Functions for use.
string getInput();
bool validateInput(string userInput);
double calcSeriesResult(int number);
void displayResults(int number, int seriesSum);

int main()
{
    // Initialize variables
    string inputVal; // string
    double seriesSum; // double
    int N; // N value of series
    while(true) // Continuously loop
        {
        inputVal = getInput();
        // Execute(call) the getInput() function and assign the returned value to "inputVal"
        N = stoi(inputVal); // Utilize stoi function to convert string to an integer
        // This integer represents the "N" entered value for calculation
        /**
        Stoi is a function to convert a string to an integer.
        While there are other methods to accomplish this, stoi
        simplifies the complexity of the code and accomplishes its intended
        purpose.
        **/
        if(N == 0){ // validate if the input satisfies program conditions
                // As per instructions, if zero is entered, the program will stop.
            cout << "Zero has been entered. Stopping program.";
            return 0; // exit
        }
        else { // The "N" satisfies the primary execution condition. Continue.
            seriesSum = calcSeriesResult(N); // Pass the "N" variable to the calcSeriesResult function and obtain the resulting sum
            displayResults(N, seriesSum); // show resulting output
        }
    }
    return 0;
}
string getInput()
{
    string inputValue;
    cout << endl << "Enter a valid number: ";
    cin >> inputValue;

    while(validateInput(inputValue) == false){ // loop error message as long as input isn't valid
        cout << endl << "The given input is not a valid number. Please try again.";

        // read entire line value as a string
        cin.ignore(); // necessary ignore
        getline(cin,inputValue);
    }
    return inputValue;
}
bool validateInput(string userInput)
{
    for(int counter = 0; counter < userInput.length(); counter++){
       if(isdigit(userInput[counter])== false || userInput[counter] == 1){
            //The isdigit() function checks if the value is a digit or not i.e one of 0,1,2,3,4,5,6,7,8 and 9.
            // As part of the C++ standard library, this is the easiest way to validate input as an appropriate integer
            return false;
        }
    }
    return true;
}
double calcSeriesResult(int number)
{
    double calcResult = 0;
    for(int counter = 0; counter < number; counter++){
        //If the number entered is N, sum the series 1/N + 2/(N-1) + 3/(N-2)+ … +N/1.  Display the original number and the sum. (Instructions)
        calcResult = calcResult + ( counter + 1 ) /( (double)number - counter); // cumulative series calculation formula. number is casted from an Integer to Double.
    }
    return calcResult;
}
void displayResults(int number, int seriesSum)
{
 cout << endl << "Given the number " << number << ", the resulting sum of the series is " << seriesSum << endl;
}
