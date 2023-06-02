// Implement a factory fromJson constructor so that it's possible to create Person instances from a map of key-value pairs. This should handle the case where the name and age values are missing or have the wrong type.
// Implement a toJson() method so that a Person instance can be converted back to a Map<String, Object>.

void main() {
  final person = Person.fromJson({
    'name': 'Andrea',
    'age': 36,
  });
  final json = person.toJson();
  print(json);
}

class Person {
  Person({required this.name, required this.age});
  final String name;
  final int age;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        name: json['name'],
        age: json['age'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
      };
}
