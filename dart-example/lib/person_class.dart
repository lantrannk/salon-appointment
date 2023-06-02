// Given the following program:

// void main() {
//   final person = {
//     'name': 'Andrea',
//     'age': 36,
//     'height': 1.84
//   };
//   print("My name is ${person['name']}. I'm ${person['age']} years old, I'm ${person['height']} meters tall.");
// }

// Refactor this code by creating a Person class that will contain name, age, height properties.
// This class should have a printDescription() method that can be used to print the name, age and height just like in the program above.
// Once this is done, create two instances of Person and use them to call the printDescription() method just created.

void main() {
  var person1 = Person('Andrea', 36, 1.84);
  var person2 = Person('Minnie', 25, 1.60);

  person1.printDescription();
  person2.printDescription();
}

class Person {
  String name;
  int age;
  double height;

  Person(this.name, this.age, this.height);

  void printDescription() {
    print('My name is $name. I\'m $age years old, I\'m $height meters tall.');
  }
}
