// Create a program that asks the user to enter their name and their age.
// Print out a message that tells how many years they have to be 100 years old.

import 'dart:io';

void main() {
  /// Create nullable variables with ? after the type
  String? name;
  int? age;

  /// Get [name] from user until [name] != [null]
  while (name == null) {
    print('What\'s your name?');
    name = stdin.readLineSync();
  }

  /// Get [age] from user until [age] != null and [name] > 0
  while (age == null || age <= 0) {
    print('Hi $name! How old are you now?');
    age = int.tryParse(stdin.readLineSync()!);
  }

  /// Calculate number of years to be 100
  final int yearToHundred = 100 - age;

  /// Print out result follow number that calculated above
  /// Using conditional expressions
  print((yearToHundred >= 0)
      ? '$name, you have ${100 - age} years to be 100.'
      : '$name, you were greater than 100 years old.');
}
