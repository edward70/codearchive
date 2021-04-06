// Fourth C++ program, finally getting exciting!

#include <iostream>

using namespace std;  // Include using statement outside to include std for all functions.
int money; // Variable declared out of main to make it global.

void balance() {
  cout << "You have $" << money << " in your bank account" << endl;
}

void deposit(int cash) { // Declare integer argument 'cash'
  money = money + cash;
  balance();
}

void withdraw(int cash) {
  money = money - cash;
  balance();
}

int main() {
  money = 10;
  balance();
  deposit(3);
  withdraw(3);
  return 0;
}