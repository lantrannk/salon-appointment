// Write a password generator in Dart.
// Be creative with how you generate passwords - strong passwords have a mix of lowercase letters, uppercase letters, numbers, and symbols.
// The passwords should be random, generating a new password every time the user asks for a new password.
// Include your run-time code in a main method.
// Ask the user how strong they want their password to be.
// For weak passwords, pick a word or two from a list.

import 'dart:io';
import 'dart:math';

void main() {
  /// Create a nullable variable
  String? choice;

  /// Get [choice] from user
  while (choice == null) {
    print('How strong you want your password to be? Weak, Medium, or Strong.');
    choice = stdin.readLineSync();
  }

  /// Call functions to print out the password generated
  generatePassword(choice.toLowerCase());
}

/// Function: Random a password [String] and prints out
/// Generates a [List] of char code
/// Using from char code to get a [String]
void randomPassword(int strength) {
  print(
    String.fromCharCodes(
      List.generate(strength, (_) => Random().nextInt(94) + 33),
    ),
  );
}

/// Function: Generate a password with strength from user
void generatePassword(String strength) {
  /// Initialize a [List] of words
  const List<String> words = [
    'good',
    'password',
    'birth',
    'lucky',
    'example',
    'money',
    'rice',
    'apple',
    'melon',
    'water'
  ];

  switch (strength) {
    /// Get one or two words from the list to generate a weak password
    case 'weak':
      String password = List.generate(Random().nextInt(2) + 1,
          (_) => words[Random().nextInt(words.length)]).join();
      print(password);
      break;

    /// Using function to random a password
    case 'medium':
      randomPassword(15);
      break;
    case 'strong':
      randomPassword(25);
      break;
    default:
      print('Incorrect choice.');
  }
}
