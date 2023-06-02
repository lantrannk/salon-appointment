// Implement a countdown function that takes an int n argument, and prints all the numbers from n to 0, with one second delay between each number.
// Then, call countdown(5) inside the main() method, and verify that it works as intended.
// The program should print Done after the countdown has completed.
// Use Futures, async and await as needed.

void main() {
  countdown(5);
}

Future<void> countdown(int n) async {
  for (int i = n; i >= 0; i--) {
    await Future.delayed(
      Duration(seconds: 1),
      () => print(i),
    );
  }
  print('Done');
}
