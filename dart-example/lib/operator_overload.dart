// Implement the + operator, so that it's possible to add two instances of type Point.
// Implement the * operator, so that it's possible to multiply a Point with an int value.
// Once you have done this, the print statements in the main method should compile and print the correct result.

void main() {
  print(Point(1, 2) == Point(1, 3));
  // make this compile by overriding the + operator
  print(Point(1, 1) + Point(2, 0)); // should print: Point(3, 1)
  // make this compile by overriding the * operator
  print(Point(2, 1) * 5); // should print: Point(10, 5)
}

class Point {
  const Point(this.x, this.y);
  final int x;
  final int y;

  @override
  String toString() => 'Point($x, $y)';

  @override
  bool operator ==(covariant Point other) {
    return x == other.x && y == other.y;
  }

  Point operator +(covariant Point other) {
    return Point(x + other.x, y + other.y);
  }

  Point operator *(covariant int number) {
    return Point(x * number, y * number);
  }
}
