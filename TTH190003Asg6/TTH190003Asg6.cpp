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





#include <string> // string class
#include <iostream>
#include <iomanip>

using namespace std;

// Function Prototype
bool isPalindrome(string input);

int main(int argc, char const* argv[]) // Driver Function
{
	// asks for a string,
	string phrase;
	while (true)
	{
		cout << "Enter string: ";
		getline(cin, phrase);
		if (phrase == "*")
			break;
		// displays the string, and prints whether it is a palindrome
		cout << phrase;
		if (isPalindrome(phrase))
			cout << " is a palindrome\n";
		else
			cout << " is not a palindrome\n";
	}
	return 0;
}


bool isPalindrome(string input) // Only ONE parameter given
{

	/*
	To determine if it is a palindrome we need to look at each character and compare. To do that, we first need the string's length.
	This can be found from the length() function.
	*/

	int inputLen = input.length();

     /*
	 * Next, we need to check if the character at index 0, (the first character) is alphabetic.
	 */
	if (isalpha(input[0])) // is the first character of the string an alphabetic letter? (T/F)
	{
		int lastIndex = inputLen - 1; // get the position of the last character in the string
		if (isalpha(input[lastIndex])) // is the last character of the string an alphabetic letter? (T/F)
		{
			/*
			* If so, we need to check if the two match. (Are they the same?)
			*/

			/*
			* To account for possible differences in capitalization, we use the toUpper() function to standardize our data and treat it as the same.
			*/

			if (toupper(input[0]) == toupper(input[lastIndex])) // is the standardized first character equal to the standardized last character in the string?
			{
				// if the length the length of the input is only 2, and the first and last are the same, we can conclude it is a palindrome.
				if (input.length() == 2) {
					return true; // It is a palindrome
				}
				else {
					// we can can not conclude if its a palindrome on this recursion. Thus, we must make a recursive call.
					return isPalindrome(input.substr(1, inputLen - 2)); // A recursive function call is made using the substring function to determine a new parameter based on the shifted character position
				}
			}
			else // If the first and last aren't the same character, it can't be a palindrome no matter what.
			{
				return false;  // It is NOT a palindrome
			}
		}
		else // if the first character is not an alphabetical character, make a recursive call and shift the position
		{
			return isPalindrome(input.substr(0, inputLen - 2)); // A recursive function call is made using the substring function to determine a new parametered based on the shifted character position.
		}
	}

	/*
	* If we only have a singular character for our string input we can conclude by default that it is a palindrome.
	*/
	if (input.length() == 1) // is the length of the input 1?
	{
		return true; // It is a palindrome
	}

	/*
	* After logic has been performed, another recursive function must be executed to shift the character position.
	*/
	return isPalindrome(input.substr(1)); // A recursive function call is made using the substring function to determine a new parameter based on the shifted character position.
}
