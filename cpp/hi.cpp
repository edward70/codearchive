// Just a simple text adventure game using functions. XD

#include <iostream>
#include <string>

using namespace std;

// Global Variables
string inventory[10][2];
string name;

void askname() {
  cout << "What's your Name? ";
  cin >> name;
  cout << endl << "Hello " << name << "." << endl;
}

void initinventory() {
  inventory[0][0] = "Apple";
  inventory[0][1] = "You don't really like fruit.";
  inventory[1][0] = "Paper";
  inventory[1][1] = "You can write on it if you have a pencil.";
  inventory[2][0] = "Rock";
  inventory[2][1] = "This rock is an interesting color :O";
}

int options(bool move, bool inventory) {
  if (move == true) {
  
  }
}

void storybegins() {
  cout << endl;
  cout << "=== THE STORY BEGINS ===" << endl;
  cout << endl;
  cout << "You are lost in a dazzle of green, a strange dense forest." << endl;
  cout << "Hopefully you can get back home before your parents notice." << endl;
}

int main() {
  askname();
  initinventory();
  storybegins();
  return 0;
}