// Create a program that asks the user for a number and then prints out a list of all the divisors of that number.

import 'dart:io';

void main() {
  /// Create a nullable variable
  int? num;

  /// Get [num] from user until [num] != 0
  while (num == null) {
    print('Enter a number:');
    num = int.tryParse(stdin.readLineSync()!);
  }

  /// Create a [List] of [int] and initialize it with 2 elements
  List<int> divisors = [1, num];

  /// Insert divisor of [num] into [List] with index is length of list minus 1
  /// Using collection if
  for (int i = 2; i <= num / 2; i++) {
    divisors.insertAll(divisors.length - 1, [if (num % i == 0) i]);
  }

  /// Print out [List] of divisors of [num]
  print(divisors);
}
