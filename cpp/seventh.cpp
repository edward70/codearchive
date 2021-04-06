// My seventh program, a demo of the switch statement.

#include <iostream>
using namespace std;

int main() {
  int val;
  cout << "Input an integer between 1 and 3." << endl;
  cin >> val;
  switch(val) {
    case 1: 
      cout << "You inputed the number one!" << endl;
      break;
    case 2:
      cout << "Yay, the number two was inputed!" << endl;
      break;
    case 3:
      cout << "Wow! You chose three!" << endl;
      break;
    default :
      cout << "Aww, that was an invalid input!" << endl;
      break;
  }
  return 0;
}