// Take a list, say for example this one:
//  a = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
// and write a program that prints out all the elements of the list that are less than 5.

void main() {
  /// Create a constant [List] of [int]
  const List<int> a = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89];

  /// Print out a [List] from list created with all elements less than 5
  /// Using collection for and collection if
  print([
    for (int i in a)
      if (i < 5) i
  ]);
}
