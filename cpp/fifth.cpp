// Fifth program demonstrating functional programming

#include <iostream>
using namespace std;
int bananas;
int apples;

void eat_a(int num) {
  apples = apples - num;
  cout << num << " apples were eaten! Now you have " << apples << " apples." << endl;
}

void keep_a(int num) {
  apples = apples + num;
  cout << num << " apples have been kept! Now you have " << apples << " apples." << endl;
}

void askeat_a() {
  int eatnum;
  cout << "How many apples do you want to eat?" << endl;
  cin >> eatnum;
  eat_a(eatnum);
}

void askkeep_a() {
  int keepnum;
  cout << "How many apples do you want to keep?" << endl;
  cin >> keepnum;
  keep_a(keepnum);
}

void eat_b(int num) {
  bananas = bananas - num;
  cout << num << " bananas were eaten! Now you have " << bananas << " bananas." << endl;
}

void keep_b(int num) {
  bananas = bananas + num;
  cout << num << " bananas have been kept! Now you have " << bananas << " bananas." << endl;
}

void askeat_b() {
  int eatnum;
  cout << "How many banana's do you want to eat?" << endl;
  cin >> eatnum;
  eat_b(eatnum);
}

void askkeep_b() {
  int keepnum;
  cout << "How many banana's do you want to keep?" << endl;
  cin >> keepnum;
  keep_b(keepnum);
}

int main() {
  apples = 9;
  bananas = 10;
  while(1) {
    int a_or_b;
    cout << "Apples or bananas? (1 or 2)" << endl;
    cin >> a_or_b;
    if(a_or_b == 1) {
      int e_or_k_a;
      cout << "Eat or keep? (1 or 2)" << endl;
      cin >> e_or_k_a;
      if(e_or_k_a == 1) {
        askeat_a();
      } else {
        askkeep_a();
      }
    } else {
      int e_or_k_b;
      cout << "Eat or keep? (1 or 2)" << endl;
      cin >> e_or_k_b;
      if(e_or_k_b == 1) {
        askeat_b();
      } else {
        askkeep_b();
      }
    }
  }
  return 0;
}