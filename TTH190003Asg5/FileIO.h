#pragma

#include <iostream>
using namespace std;

class FileIO
{


private: // private methods/objects
    string employeeID;
    string lastName;
    string firstName;
    string birthdayDate;
    string empGender;
    string startingDate;
    double empSalary;
    int employeeNum;



public:
    FileIO();
    FileIO(int employeeNum);

    /**
    void newEmp(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int& employeeNum);

    void getList(ifstream& inputFile, string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int& employeeNum);

    void userInputPrompt(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int employeeNum);
    **/


/**
    void newEmp(string employeeId[], string lastName[], string firstName[], string birthDate[], string gender[], string startDate[], double salary[], int& employeeNum)
    {
        string employeeId_new, lastName_new, firstName_new, birthDate_new, startDate_new, gender_new;
        double salary_new;


        cout << "Insert New Employee Id:" << endl;
        cin >> employeeId_new;
        employeeId[employeeNum] = employeeId_new;

        cout << "Insert New Employee Last Name:" << endl;
        cin >> lastName_new;
        lastName[employeeNum] = lastName_new;

        cout << "Insert New Employee First Name:" << endl;
        cin >> firstName_new;
        firstName[employeeNum] = firstName_new;

        cout << "Insert New Employee Birth Date (MM / DD / YYYY):" << endl;
        cin >> birthDate_new;
        birthDate[employeeNum] = birthDate_new;

        cout << "Insert New Employee Gender:" << endl;
        cin >> gender_new;
        gender[employeeNum] = gender_new;

        cout << "Insert New Employee Start Date (MM / DD / YYYY):" << endl;
        cin >> startDate_new;
        startDate[employeeNum] = startDate_new;

        cout << "Insert New Employee's Salary (in dollars) :" << endl;
        cin >> salary_new;
        salary[employeeNum] = salary_new;

        ofstream fp_out;
        fp_out.open("Employee.txt", std::ios_base::app); //Writing (appending) the values back to text file
        fp_out << employeeId[employeeNum] << " " << lastName[employeeNum] << " " << firstName[employeeNum] << " " << birthDate[employeeNum] << " " << gender[employeeNum] << " " << startDate[employeeNum] << " " << salary[employeeNum] << endl;

        employeeNum++; // Increment size of list

    }
**/

};


