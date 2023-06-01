// Randomly generate a 4-digit number.
// Ask the user to guess a 4-digit number.
// For every digit the user guessed correctly in the correct place, they have a “cow”.
// For every digit the user guessed correctly in the wrong place is a “bull.”

// Every time the user makes a guess, tell them how many “cows” and “bulls” they have.
// Once the user guesses the correct number, the game is over.
// Keep track of the number of guesses the user makes throughout the game and tell the user at the end.

import 'dart:io';
import 'dart:math';

void main() {
  List<String> givenNumber =
      List.generate(4, (_) => Random().nextInt(10).toString());
  print(givenNumber.join());

  String? number;
  int guesses = 0;

  while (true) {
    print('Enter a 4-digit number:');
    number = stdin.readLineSync();

    if (number == null ||
        int.tryParse(number) == null ||
        number.length != givenNumber.length) {
      print('Incorrect number. pLease enter a 4-digit number.');
      continue;
    }

    Map<String, int> result = cbGame(number, givenNumber);
    guesses++;
    if (result['cow'] == 4) {
      print('The number $number is correct. You guess $guesses times.');
      break;
    } else {
      print('Cows: ${result['cow']} - Bulls: ${result['bull']}\n');
    }
  }
}

Map<String, int> cbGame(String num, List<String> givenNumber) {
  List<String> number = num.split('');

  int cow = 0;
  int bull = 0;

  for (int i = 0; i < number.length; i++) {
    if (number[i] == givenNumber[i]) {
      cow++;
    } else if (givenNumber.contains(number[i])) {
      bull++;
    }
  }

  return {
    'cow': cow,
    'bull': bull,
  };
}
