#include "Employee.h"
#include <iostream>
using namespace std;

Employee::Employee() // Employee Class (default values)
{
	employeeId = "";
	lastName = "";
	firstName = "";
	birthDate = "";
	gender = "";
	startDate = "";
	salary = 0.0;
}

Employee::Employee(string eId) // ID only default value
{
	employeeId = eId;
	lastName = "";
	firstName = "";
	birthDate = "";
	gender = "";
	startDate = "";
	salary = 0.0;
}
Employee::Employee(string eId, string lName, string fName, string bDate, string gen, string sDate, double sal) // Employee class instantiated with attributes from the main C++ file
{
	employeeId = eId;
	lastName = lName;
	firstName = fName;
	birthDate = bDate;
	gender = gen;
	startDate = sDate;
	salary = sal;
}

// functions inherit attribute values from class with every new class instance

void Employee::setEmployeeId(string eId) // function object derived from class
{
	employeeId = eId; // attribute value derived from instantiation
}

void Employee::setLastName(string lName) // function object derived from class
{
	lastName = lName; // attribute value derived from instantiation
}

void Employee::setFirstName(string fName) // function object derived from class
{
	firstName = fName; // attribute value derived from instantiation
}

void Employee::setBirthDate(string bDate) // function object derived from class
{
	birthDate = bDate; // attribute value derived from instantiation
}

void Employee::setGender(string gen) // function object derived from class
{
	gender = gen; // attribute value derived from instantiation
}

void Employee::setStartDate(string sDate)
{
	startDate = sDate; // attribute value derived from instantiation
}

void Employee::setSalary(double sal) // function object derived from class
{
	salary = sal; // attribute value derived from instantiation
}

string Employee::getEmployeeId() // retrieves value from attribute at that class instance *
{
	return employeeId; // returned to main C++ file
}

string Employee::getLastName()
{
	return lastName; // returned to main C++ file
}

string Employee::getFirstName()
{
	return firstName; // returned to main C++ file
}

string Employee::getBirthDate()
{
	return birthDate; // returned to main C++ file
}

string Employee::getGender()
{
	return gender; // returned to main C++ file
}

string Employee::getStartDate()
{
	return startDate; // returned to main C++ file
}

double Employee::getSalary()
{
	return salary; // returned to main C++ file
}
