// Generate a random number between 1 and 100.
// Ask the user to guess the number, then tell them whether they guessed too low, too high, or exactly right.
// Keep track of how many guesses the user has taken, and when the game ends, print this out.

import 'dart:io';
import 'dart:math';

void main() {
  /// Generate a random number
  final int num = Random().nextInt(101) + 1;

  /// Initialize non-nullable [int] variable number of guesses
  int guessed = 0;

  /// Create nullable [int] variable number
  int? userNum;

  while (true) {
    /// Get a number from user
    print('Enter a number:');
    userNum = int.tryParse(stdin.readLineSync()!);

    /// Check the number is invalid or not
    if (userNum == null || userNum < 1 || userNum > 100) {
      print('Invalid number.');
      continue;
    }

    /// Compare the number from user to the number generated and print out the result
    if (userNum > num) {
      print('The number you guessed is too high.');
      guessed++;
    } else if (userNum < num) {
      print('The number you guessed is too low.');
      guessed++;
    } else {
      guessed++;
      print('The number you guessed is right. You take $guessed guesses.');
      break;
    }
  }
}
