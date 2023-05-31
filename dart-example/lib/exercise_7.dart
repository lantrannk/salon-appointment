// Let’s say you are given a list saved in a variable:
// a = [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
// Write a Dart code that takes this list and makes a new list that has only the even elements of this list in it.

void main() {
  /// Create a constant [List] of [int]
  const List<int> a = [1, 4, 9, 16, 25, 36, 49, 64, 81, 100];

  /// Print out a [List] with all elements are even from list [a]
  /// Using collection for and collection if
  print([
    for (int i in a)
      if (i.isEven) i
  ]);
}
