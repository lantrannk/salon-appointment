// Add a new perimeter getter variable to the Shape class, and implement it in all subclasses.
// Then, add a new printValues() method to the Shape class. When called, this should print both the area and the perimeter.
// Finally, create a list of shapes that contains Squares and Circles and call the printValues() method on each item.

import 'dart:math';

void main() {
  List<Shape> shapes = [Square(4), Circle(3), Circle(2), Square(1)];

  for (var shape in shapes) {
    shape.printValues();
  }
}

abstract class Shape {
  double get area;
  double get perimeter;

  void printValues() {
    print(
        'Area: ${area.toStringAsFixed(2)} - Perimeter: ${perimeter.toStringAsFixed(2)}');
  }
}

class Square extends Shape {
  Square(this.side);
  final double side;

  @override
  double get area => side * side;

  @override
  double get perimeter => 4 * side;
}

class Circle extends Shape {
  Circle(this.radius);
  final double radius;

  @override
  double get area => pi * radius * radius;

  @override
  double get perimeter => 2 * pi * radius;
}
