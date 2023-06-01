// Ask the user for a number and determine whether the number is prime or not.
// Do it using a function

import 'dart:io';

void main() {
  /// Create a nullable variable
  int? num;

  /// Get [num] from user
  while (num == null) {
    print('Enter a number:');
    num = int.tryParse(stdin.readLineSync()!);
  }

  /// Prints out [num] is a prime or not
  /// Using function created
  print(
    (isPrime(num)) ? 'The number is a prime.' : 'The number is not a prime.',
  );
}

/// Function: check [num] is a prime or not
/// A prime is a number that has only 2 divisors one and itself
bool isPrime(int num) {
  if (num == 0 || num == 1) {
    return false;
  }

  for (int i = 2; i <= num / 2; i++) {
    if (num % i == 0) {
      return false;
    }
  }
  return true;
}
