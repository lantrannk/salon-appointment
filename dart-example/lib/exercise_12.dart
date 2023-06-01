// Write a program that asks the user how many Fibonacci numbers to generate and then generates them.
// Take this opportunity to think about how you can use functions.
// Make sure to ask the user to enter the number of numbers in the sequence to generate.

import 'dart:io';

void main() {
  /// Create a nullable variable
  int? num;

  /// Get [num] from user
  while (num == null || num < 2) {
    print('Enter a number:');
    num = int.tryParse(stdin.readLineSync()!);
  }

  /// Prints out the list of fibonacci with length equal to [num]
  print(fibonacci(num));
}

/// Function: Makes a [List] of Fibonacci with param is [num] from user
List<int> fibonacci(int num) {
  List<int> fibonacci = [1, 1];

  for (int i = 2; i < num; i++) {
    fibonacci.add(fibonacci[i - 1] + fibonacci[i - 2]);
  }

  return fibonacci;
}
