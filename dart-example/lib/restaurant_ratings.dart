// Add some new functionality to this class so that it can be used to:
// - get the total number of ratings
// - calculate the average rating (use a for loop or the reduce operator)

void main() {
  var rest = Restaurant(
    name: 'Croissant',
    cuisine: 'French',
    ratings: [4, 5, 3, 5, 3, 2, 5, 1, 4, 2, 5, 1, 3, 4, 2, 3, 2, 5, 4, 2],
  );

  print(
      'Number of ratings: ${rest.totalRatings()} - Ratings: ${rest.averageRatings()}');
}

class Restaurant {
  const Restaurant({
    required this.name,
    required this.cuisine,
    required this.ratings,
  });

  final String name;
  final String cuisine;
  final List<double> ratings;

  int totalRatings() => ratings.length;

  double averageRatings() => ratings.reduce((a, b) => a + b) / totalRatings();
}
