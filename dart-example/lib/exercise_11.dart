// Write a program that takes a list of numbers for example
// a = [5, 10, 15, 20, 25]
// and makes a new list of only the first and last elements of the given list.
// For practice, write this code inside a function

void main() {
  /// Initialize a constant list
  const List<int> a = [5, 10, 15, 20, 25];

  /// Prints out the list with the first and the last elements of given list
  /// Using function created
  print(getFirstLastElements(a));
}

/// Function: get the first and the last elements of a list to a new list
/// Using a shorthand syntax
List<int> getFirstLastElements(List<int> list) => [list.first, list.last];
