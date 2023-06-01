// Write a program (using functions!) that asks the user for a long string containing multiple words.
// Print back to the user the same string, except with the words in backwards order.

import 'dart:io';

void main() {
  String? string;

  while (string == null) {
    print('Enter a long string:');
    string = stdin.readLineSync();
  }

  print(backwardsStr(string));
}

String backwardsStr(String string) => string.split(' ').reversed.join(' ');
