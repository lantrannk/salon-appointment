// Ask the user for a number.
// Depending on whether the number is even or odd, print out an appropriate message to the user.

import 'dart:io';

void main() {
  /// Create a nullable variable
  int? num;

  /// Get [num] from user until [num] != 0
  while (num == null) {
    print('Enter a number:');
    num = int.tryParse(stdin.readLineSync()!);
  }

  /// Print out [num] is even or odd
  /// Using conditional expressions
  print((num.isEven) ? '$num is even.' : '$num is odd.');
}
