// Make a two-player Rock-Paper-Scissors game against computer.
// Ask for player’s input, compare them, print out a message to the winner.

import 'dart:io';
import 'dart:math';

void main() {
  // Create constant
  const List<String> options = ['rock', 'paper', 'scissors', 'exit'];
  const Map<String, String> rules = {
    'rock': 'paper',
    'paper': 'scissors',
    'scissors': 'rock',
  };

  // Initialize [int] point of computer and player
  int playerPoint = 0;
  int compPoint = 0;

  // Create a nullable variable
  String? playerChoice;

  while (true) {
    // Random computer choice from list of options
    String compChoice = options[Random().nextInt(3)];

    // Get an option from user
    print('Choose an option:\n$options');
    playerChoice = stdin.readLineSync()!.toLowerCase();

    // Check [options] contains player's choice or not
    if (!options.contains(playerChoice)) {
      print('Incorrect option.');
      continue;
    }

    // Stop program when player's choice is exit
    if (playerChoice == 'exit') {
      break;
    }

    // Compare player's choice to computer's choice and print out result
    if (compChoice == playerChoice) {
      print('We have a tie!');
    }

    if (rules[playerChoice] == compChoice) {
      compPoint++;
      print('The computer won.\nScore: $playerPoint - $compPoint');
    }

    if (rules[compChoice] == playerChoice) {
      playerPoint++;
      print('The player won.\nScore: $playerPoint - $compPoint');
    }
  }
}
