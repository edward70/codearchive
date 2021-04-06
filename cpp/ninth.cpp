// Ninth program, a demo of structs.

#include <iostream>
#include <string>
using namespace std;
struct profile {
  string first_name;
  string last_name;
  int age;
  string about_me;
  string status;
  string location;
};
int main() {
  profile edward = {
    "Edward",
    "[REDACTED]",
    12,
    "I write code.",
    "Writing code... duh.",
    "Australia"
  };

  cout << "edward.first_name is " << edward.first_name << "." << endl;
  cout << "edward.last_name is " << edward.last_name << "." << endl;
  cout << "edward.age is " << edward.age << "." << endl;
  cout << "edward.about_me is " << edward.about_me << "." << endl;
  cout << "edward.status is " << edward.status << "." << endl;
  cout << "edward.location is " << edward.location << "." << endl;
}
