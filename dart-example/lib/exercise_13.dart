// Write a program (function) that takes a list and returns a new list
// that contains all the elements of the first list minus all the duplicates.

import 'dart:math';

void main() {
  /// Generate a random [List]
  List list = List.generate(10, (_) => Random().nextInt(10));

  /// Prints out the given list and the list after removing duplicates
  print('The given list: $list => ${rmDuplicates(list)}');
}

/// Function: Remove duplicates from a [List]
/// Using a shorthand syntax
List rmDuplicates(List list) => list.toSet().toList();
