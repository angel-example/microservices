abstract class MyApiScopes {
  static const List<String> all = const <String>[
    performFibonacci,
    performSquareRoot
  ];

  static const String performFibonacci = 'fibonacci',
      performSquareRoot = 'square_root';
}
