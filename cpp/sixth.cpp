// Array demo

#include <iostream>
using namespace std;

int main() {
  int array[3];
  array[0] = 1234;
  array[1] = 3215;
  array[2] = 0000;
  while(1) {
    int chosen;
    cout << "Enter a number to view or change. (1, 2 or 3)" << endl;
    cin >> chosen;
    int chosen2;
    cout << "View or change? (1 or 2)" << endl;
    cin >> chosen2;
    if(chosen2 == 1) {
      cout << "Number " << chosen << " has a value of " << array[chosen - 1] << endl;
    } else {
      int changenum;
      cout << "What do you want to change this number to?" << endl;
      cin >> changenum;
      array[chosen - 1] = changenum;
    }
  }
  return 0;
}