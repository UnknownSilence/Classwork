#pragma

#include <iostream>
using namespace std;

class Employee // Employee class declaration for use
{
private: // private methods/objects
    string firstName;
    string lastName;
    string employeeID;
    string birthdayDate;
    string empGender;
    string startingDate;
    double empSalary;

public: // public methods/objects
    Employee();
    Employee(string empID);
    // empID ~ employeeID
    // nameL ~ lastName
    // nameF ~ firstName
    // birthDate ~ birthdayDate
    // gender ~ empGender
    // startDate ~ startingDate
    // salary ~ empSalary
    Employee(string empID, string nameL, string nameF, string birthDate, string gender, string startDate, double salary);

    // Having user set new data values
    void setEmployeeId(string empID);
    void setFirstName(string nameF);
    void setLastName(string nameL);
    void setGender(string gender);
    void setBirthDate(string birthDate);
    void setStartDate(string startDate);
    void setSalary(double salary);

    // gather saved personal info(strings)
    string getEmployeeId();
    string getFirstName();
    string getLastName();
    string getGender();
    string getBirthDate();
    string getStartDate();

    // gather saved salary
    double getSalary();

};

