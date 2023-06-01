// Time for some fake graphics! Let’s say we want to draw game boards that look like this:

//  --- --- ---
// |   |   |   |
//  --- --- ---
// |   |   |   |
//  --- --- ---
// |   |   |   |
//  --- --- ---
// This one is 3x3 (like in tic tac toe).

// Ask the user what size game board they want to draw, and draw it for them to the screen using Dart’s print statement.

import 'dart:io';

void main() {
  /// Create a nullable variable
  int? size;

  /// Get [size] from user
  while (size == null) {
    print('What size game board you want to draw? Please enter a number.');
    size = int.tryParse(stdin.readLineSync()!);
  }

  /// Draw board with the size from user
  drawBoard(size);
}

/// Function: Draw a board with param [int] size
void drawBoard(int size) {
  String rowLine = ' ---';
  String colLine = '|   ';

  for (int i = 0; i < size; i++) {
    print('${rowLine * size} ');
    print('${colLine * size}|');
  }
  print('${rowLine * size} ');
}
