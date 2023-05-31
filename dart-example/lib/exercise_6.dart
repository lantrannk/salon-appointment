// Ask the user for a string and print out whether this string is a palindrome or not.
// A palindrome is a string that reads the same forwards and backwards.

import 'dart:io';

void main() {
  /// Create nullable variables with ? after the type
  String? word;

  /// Get [word] from user until [word] != [null]
  while (word == null) {
    print('Enter a word:');
    word = stdin.readLineSync();
  }

  /// Reverse [word] and convert to lowercase
  String reversedWord = word.split('').reversed.join().toLowerCase();

  /// Print out [word] is a palindrome or not
  print((word.toLowerCase() == reversedWord)
      ? 'The word is a palindrome.'
      : 'The word is not a palindrome.');
}
