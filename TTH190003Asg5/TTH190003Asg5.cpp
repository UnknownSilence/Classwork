/******************************************************************************
 * Simple Employee Tracking System
 * Author: Trent Hardy
 * Date: 4/6/2021
 *
 * Create a program to track employee information.
 *
 * It should track: Employee ID, First Name, Last Name, Gender, Birth Date, Start Date, and annual Salary for each employee
 *
 * Must have two constructors: - No arguments, Takes all info
 *
 * A Menu will show the following options:
 *    - Enter a new employee info
 *    - Display all employee info in alphabetical order by name
 *    - Increment the count of elements in the array
 *    - Look up an employee by ID
 *    - Remove an employee
 *    - Save all data to Employee.txt and exit
 *
 * When the end of a file is reached, all numbers should be sorted and printed.
 *
 * Once program is complete, loop back and prompt user for another file name
 *
 *
 *
 * Written by Trent Hardy (tth190003) at The University of Texas at Dallas
 * Major: Computer Science (B.S.)
 * Started Wednesday, March 31, 2021
 * Finished Tuesday, April 6, 2021
 ******************************************************************************/






#include <iostream>
#include <cstdlib>
#include <iomanip>
#include <fstream>
#include "Employee.h"
#include "FileIO.h"

using namespace std;


// Function Prototypes

void userInputPrompt(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int employeeNum);

void newEmp(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int& employeeNum);

void getList(ifstream& inputFile, string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int& employeeNum);

void displayListRes(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int employeeNum);

void sortIDArray(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int employeeNum);

void showEmpList(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int employeeNum);

void removeEmployee(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int& employeeNum);

void displayListResById(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int employeeNum);











const int maxNumEmployees = 100; // max number of employees as indicated in instructions (array cap)

int main()
{

    //Initialize double array for annual salary
    double salary[maxNumEmployees];

    // Initialize counter variable for employee number
    int employeeNum = 0;

    // Initialize string arrays
    string employeeId[maxNumEmployees];
    string lastName[maxNumEmployees];
    string firstName[maxNumEmployees];
    string birthDate[maxNumEmployees];
    string gender[maxNumEmployees];
    string startDate[maxNumEmployees];


    ifstream inputFile;
    inputFile.open("Employee.txt");

    if (inputFile.fail()) // check if doesn't exist
    {
        //ERROR OPENING FILE, INSTEAD: CREATING IT
        ofstream inputFile("Employee.txt");
    }

    ifstream theData;

    getList(inputFile, employeeId, lastName, firstName, birthDate, gender, startDate, salary, employeeNum);
    userInputPrompt(employeeId, lastName, firstName, birthDate, gender, startDate, salary, employeeNum);

    return 0;
}

// get the employee list info from the txt file
void getList(ifstream& InFile, string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int& employeeNum)
{
    int counter = 0; // keep track of iteration
    // Read in data to file
    InFile >> employeeId[counter] >> lastName[counter] >> firstName[counter] >> birthDate[counter] >> gender[counter] >> startDate[counter] >> salary[counter];

    while (!InFile.eof()) // check and loop through entire file until the end
    {
        counter = counter + 1; // Increment pointer
        InFile >> employeeId[counter] >> lastName[counter] >> firstName[counter] >> birthDate[counter] >> gender[counter] >> startDate[counter] >> salary[counter]; // read in
    }

    employeeNum = counter;

}

// Should be in FileIO class function?? Confused here.

void userInputPrompt(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int employeeNum)
{

    int choice;

    do
    {
        cout << "Menu:" << endl;
        cout << "====================================" << endl;
        cout << "1.) Enter new employee information" << endl;
        cout << "2.) Display all employee info" << endl;
        cout << "3.) Look up an employee by ID" << endl;
        cout << "4.) Remove an Employee" << endl;
        cout << "5.) Exit Program" << endl;
        cout << "Enter choice: ";

        cin >> choice; // gather user input

        if (choice >= 1 && choice <= 4) // check if input is valid
        {
            switch (choice)
            {
            case 1:

                // add a new employee by calling fuction
                newEmp(employeeId, lastName, firstName, birthDate, gender, startDate, salary, employeeNum);

                // call function to show updated list
                displayListRes(employeeId, lastName, firstName, birthDate, gender, startDate, salary, employeeNum);

                break;

            case 2:

                // call function to sort the list in order of ID
                sortIDArray(employeeId, lastName, firstName, birthDate, gender, startDate, salary, employeeNum);

                // call function to show updated list
                showEmpList(employeeId, lastName, firstName, birthDate, gender, startDate, salary, employeeNum);

                break;

            case 3:

                // call function to show list
                displayListResById(employeeId, lastName, firstName, birthDate, gender, startDate, salary, employeeNum);

                break;

            case 4:

                // call function to delete employee from memory
                removeEmployee(employeeId, lastName, firstName, birthDate, gender, startDate, salary, employeeNum);

                // call function to show updated list
                displayListRes(employeeId, lastName, firstName, birthDate, gender, startDate, salary, employeeNum);

                break;


            }

        }
        else if (choice != 5)
        {
            cout << "Invalid Choice. Try again.";
        }
    }
    while (choice != 5);   // loop until exit condition is met
}

void newEmp(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int& employeeNum)
{
    // variables to hold values for new employee insertion
    string newEmployeeId;
    string newEmpLastName;
    string newEmpFirstName;
    string newEmpBirthDate;
    string newEmpStartDate;
    string newEmpGender;
    double newEmpSalary;


    cout << "Enter New Employee Id:" << endl;

    cin >> newEmployeeId;

    employeeId[employeeNum] = newEmployeeId;




    cout << "Enter New Employee's Last Name:" << endl;

    cin >> newEmpLastName;

    lastName[employeeNum] = newEmpLastName;




    cout << "Enter New Employee's First Name:" << endl;

    cin >> newEmpFirstName;

    firstName[employeeNum] = newEmpFirstName;




    cout << "Enter Employee's Birthday Date (MM / DD / YYYY):" << endl;

    cin >> newEmpBirthDate;

    birthDate[employeeNum] = newEmpBirthDate;




    cout << "Enter New Employee's Gender:" << endl;

    cin >> newEmpGender;

    gender[employeeNum] = newEmpGender;




    cout << "Enter New Employee's Starting Date (MM / DD / YYYY):" << endl;

    cin >> newEmpStartDate;

    startDate[employeeNum] = newEmpStartDate;




    cout << "Enter New Employee's Salary (in dollars) :" << endl;

    cin >> newEmpSalary;


    if (newEmpSalary < 0)
    {
        do
        {
            cout << "Invalid Input, must be a positive value greater than zero" << endl;
            cin >> newEmpSalary;

        }
        while (newEmpSalary < 0); // VERIFY INPUT IS VALID
    }


    salary[employeeNum] = newEmpSalary;





    ofstream fp_out; // writing user given values into text file
    fp_out.open("Employee.txt", std::ios_base::app);



    fp_out << employeeId[employeeNum] << " " << lastName[employeeNum] << " " << firstName[employeeNum] << " " << birthDate[employeeNum] << " " << gender[employeeNum] << " " << startDate[employeeNum] << " " << salary[employeeNum] << endl;

    employeeNum++; // Increment size of list

}


void sortIDArray(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int employeeNum)
{
    string tempID;
    string tempLastName;
    string tempFirstName;
    string tempBirthDate;
    string tempGender;
    string tempStartDate;

    double tempSalary;
    int tempCounter;

    for (tempCounter = employeeNum - 1; tempCounter >= 0; tempCounter--) // Loop backwards through the list from the last entry
    {
        for (int counter = 0; counter < tempCounter; counter++) // loop through the array of the entry
        {
            if (employeeId[counter] > employeeId[counter + 1]) // compare values to determine order
            {




                // allocate temporary values to retain previous values
                tempID = employeeId[counter];
                tempLastName = lastName[counter];
                tempFirstName = firstName[counter];
                tempBirthDate = birthDate[counter];
                tempGender = gender[counter];
                tempStartDate = startDate[counter];
                tempSalary = salary[counter];





                // overwrite values of current index by shifting up 1
                employeeId[counter] = employeeId[counter + 1];
                lastName[counter] = lastName[counter + 1];
                firstName[counter] = firstName[counter + 1];
                birthDate[counter] = birthDate[counter + 1];
                gender[counter] = gender[counter + 1];
                startDate[counter] = startDate[counter + 1];
                salary[counter] = salary[counter + 1];




                // overwrite the shifted values with the temporary values retained
                employeeId[counter + 1] = tempID;
                lastName[counter + 1] = tempLastName;
                firstName[counter + 1] = tempFirstName;
                birthDate[counter + 1] = tempBirthDate;
                gender[counter + 1] = tempGender;
                startDate[counter + 1] = tempStartDate;
                salary[counter + 1] = tempSalary;

            }
        }
    } // Loops until all are sorted
}
void showEmpList(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int employeeNum)
{
    for (int counter = 0; counter < employeeNum; counter++)
    {
        cout << endl << "EmployeeId :" << employeeId[counter] << endl << "Last Name :" << lastName[counter] << endl << "FirstName : " << firstName[counter] << endl << "Birthdate : " << birthDate[counter] << endl << "Gender : " << gender[counter] << endl << "Start Date : " << startDate[counter] << endl << "Salary : " << salary[counter] << endl;
        cout << endl;
    }
}


void displayListRes(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int employeeNum)
{
    for (int counter = 0; counter < employeeNum; counter++)

        cout << endl << "EmployeeId :" << employeeId[counter] << endl << "Last Name :" << lastName[counter] << endl << "FirstName : " << firstName[counter] << endl << "Birthdate : " << birthDate[counter] << endl << "Gender : " << gender[counter] << endl << "Start Date : " << startDate[counter] << endl << "Salary : " << salary[counter] << endl;
    cout << endl;
}


void removeEmployee(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int& employeeNum)
{
    string targetEmpNum;
    int removalTargetIndex = 0;

    cout << " Which employee do you wish to remove (delete)?" << endl;

    cin >> targetEmpNum; // gather the employee to remove from the user

    while (targetEmpNum != employeeId[removalTargetIndex] && removalTargetIndex < employeeNum) // Loop through list for target searching

        removalTargetIndex++;

    if (removalTargetIndex < employeeNum) // if it exists,
    {
        // overwrite employee list values at index


        employeeId[removalTargetIndex] = employeeId[employeeNum - 1];

        lastName[removalTargetIndex] = lastName[employeeNum - 1];

        firstName[removalTargetIndex] = firstName[employeeNum - 1];

        birthDate[removalTargetIndex] = birthDate[employeeNum - 1];

        gender[removalTargetIndex] = gender[employeeNum - 1];

        startDate[removalTargetIndex] = startDate[employeeNum - 1];

        salary[removalTargetIndex] = salary[employeeNum - 1];


        employeeNum--; // Decrement size of employee list length counter
    }
}

void displayListResById(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int employeeNum)
{
    string findEmployeeId;
    cout << "Please Enter the Employee ID by you want to display the list :" << endl;
    cin >> findEmployeeId;
    bool found;

    for (int counter = 0; counter <= employeeNum; counter++)
    {
        if (findEmployeeId == employeeId[counter])
        {
            cout << "EmployeeId :" << employeeId[counter] << endl << "Last Name :" << lastName[counter] << endl << "FirstName : " << firstName[counter] << endl << "Birthdate : " << birthDate[counter] << endl << "Gender : " << gender[counter] << endl << "Start Date : " << startDate[counter] << endl << "Salary : " << salary[counter] << endl;
            cout << endl;
            return;
        }
        else
        {
            bool found = false;
            //cout << "No matching ID found" << endl;
        }

    }
    if (found == false)
    {
        cout << "No matching ID found" << endl;
    }
    cout << endl;
}
