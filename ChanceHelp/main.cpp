#include <iostream>
#include <string>
#include <algorithm>

using namespace std;

class Day
{
public:
  static int daysInMonth[12];
  enum tempMonth {jan, feb, mar, apr, may, jun, jul, aug, sep , oct, nov, dec };
  static const string monthArrayList[12] ;
  const static int YEAR;
  Day(int);
  Day(string ,int );
  void print(int numValue) const;
  Day operator ++();
  Day operator ++(int);
  Day operator --();
  Day operator --(int);
  void mutate();
  string getMonth() const;
  int getDay() const;
  friend ostream& operator <<(ostream& , const Day&);
  int day;
  enum tempMonth MonthForDay;
  int DayOfMonth;
};

// Our year
const int Day::YEAR  = 2021;
const int dayNumMax = 365;

const string Day::monthArrayList[] = {"january" , "february", "march", "april", "may", "june" , "july" , "august", "september","october","november","december"};

int Day::daysInMonth[]  = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

Day::Day(int numValue)
{
  this->day = numValue;
  mutate();
}

void Day::mutate()
{
  int tmp_days = this->day;
  int monthNum = -1;
  int remainingDays = this->day;
  for ( int i=0 ; i < 12 ; i++ )
  {
    monthNum = i ;

    if ( (remainingDays - this->daysInMonth[i] ) <= 0  )
      break ;
    else {
      remainingDays = remainingDays - this->daysInMonth[i];
      //cout << " Month " << monthArrayList[monthNum]  << " remaining days " << remainingDays << "\n";
    }
  }

  this->MonthForDay = (tempMonth) monthNum;
  DayOfMonth = remainingDays ;

}

/**
int dayOfYear(string monthName, int dayNumber)
{
    // Extract the year, month and the
    // day from the date string
    int year = Day::YEAR;
    int monthNum;

    for(int i=0; i<12; i++)
    {
        if (Day::monthArrayList[i] == monthName)
        {
           monthNum = i;
        }
    }


    // If current year is a leap year and the date
    // given is after the 28th of February then
    // it must include the 29th February
    if (monthNum > 2 && year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
        ++dayNumber;
    }

    // Add the days in the previous months
    while (monthNum-- > 0) {
        dayNumber = dayNumber + Day::daysInMonth[monthNum - 1];
    }
    return dayNumber;
}
**/

Day::Day(const string mnt ,const int day )
{
  this->day = 0;
  DayOfMonth = day;
  string month_str = mnt;
  transform(month_str.begin(), month_str.end(), month_str.begin(), ::tolower);
  for ( int i = 0 ; i < 12 ; i++ )
  {
    if ( month_str == monthArrayList[i])
    {
      this->MonthForDay = (tempMonth) i;
      break;
    }
    this->day += daysInMonth[i] ;
  }
  this->day += day;
}

void Day::print(int numValue) const
{
  cout << "day#=[" << numValue << "] " << monthArrayList[MonthForDay] << " " << DayOfMonth << endl;
}

Day Day::operator++(int)
 {
  Day tempDay(this->day);
  if (this->day + 1 > dayNumMax)
    {
      cout << "Date Overflowing";
    }
    else
    {
         this->day += 1;
         mutate();
    }
      return tempDay;
 }

Day Day::operator++()
{
  if (this->day + 1 > dayNumMax)
  {
    cout << "Date Overflowing" << endl;
  }
  else
  {
       this->day += 1;
       mutate();
  }
    return *this;
}

Day Day::operator--(int)
 {
  Day tempDay(this->day);
  if ((this->day - 1)<= 0)
    {
      cout << "Date Overflowing";
    } else {
         this->day -= 1;
         mutate();
    }
      return tempDay;
 }

Day Day::operator--()
{
  if ((this->day - 1)<= 0)
  {
    cout << "Date Overflowing";
  } else {
       this->day -= 1;
       mutate();
  }
    return *this;
}

int Day::getDay() const
{
  return DayOfMonth;
}

string Day::getMonth() const
{
  return monthArrayList[MonthForDay];
}

void test_operators(string month, int dayNum);

int main()
{

// Extra credit:
   //Day cincoDeMayo("May", 5);
   //cincoDeMayo.print();
   //Day halfway(dayNumMax/2);
   //halfway.print(); // dis

   int recentDay;
   string recentMonth;

   while (true) {
   cout << "options: d)ay [#d->m,d];  m)onth+day [m d->#d]; o)perator [+/-5]; v)arious; q)uit:" << endl;
   cout << "Choice: ";
   char choice;
   cin >> choice;
   cout << endl;
   if (choice == 'd')
   {
    cout << "enter day of year# (-9 to quit): ";
    int dayNum;
    cin >> dayNum;
    if (dayNum == -9) {
        cout << "Quitting" << endl;
    }
    else if (dayNum < 1 || dayNum > dayNumMax) {
        cout << "Invalid input" << endl;
    }
    else {
    Day TheDay(dayNum);
    TheDay.print(dayNum);
    }
   }
   else if (choice == 'm')
   {
    cout << "enter month DayOfMonth: (stop -9 to quit): ";
    string month;
    int dayNum;
    cin >> month >> dayNum;

    if (dayNum == -9 && month == "stop") {
        cout << "Quitting" << endl;
    }
    else {
    Day TheDay(month, dayNum);
    recentDay = dayNum;
    recentMonth = month;
    dayNum = TheDay.day;
    TheDay.print(dayNum);
    }

   }
   else if (choice == 'o')
   {
    test_operators(recentMonth, recentDay);
   }
   else if (choice == 'v')
   {
    // Unsure of what to put here?
    // Instructions unclear

   }
   else if (choice == 'q')
   {
       cout << "Quitting" << endl;
       break;
       return 0;

   }
   else {
    cout << "Invalid choice please try again.";
   }

   }


}

void test_operators(string month, int dayNum) {
Day TheDay(month, dayNum);
cout<<"start with most recently entered day: ";
TheDay.print(TheDay.day);
cout<<endl;
//cout <<"(use +/-5 days with --day, ++day, day++, day--):" << endl;

for (int i=0; i<5; ++i)
{
    cout << " ";
    (--TheDay).print(TheDay.day);
} cout << endl; // empty line

for (int i=0; i<5; ++i)
{
    cout << " ";
    (++TheDay).print(TheDay.day);
} cout << endl;

for (int i=0; i<5; ++i)
{
    cout<<" ";
    (TheDay++).print(TheDay.day);
} cout << endl;

for (int i=0; i<5; ++i)
{
    cout<<" ";
    (TheDay--).print(TheDay.day);
} cout << endl;

cout << "back to beginning: "; TheDay.print(TheDay.day);
cout<<endl;

}

