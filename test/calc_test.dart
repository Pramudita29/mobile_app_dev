// calculator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_nepal/calc.dart'; // Make sure this path matches where you've saved your calculator class

void main() {
  group('Calculator', () {
    final calculator = Calculator();

    test('adds two numbers', () {
      expect(calculator.add(1, 2), 3);
    });

    test('subtracts two numbers', () {
      expect(calculator.subtract(5, 2), 3);
    });

    test('multiplies two numbers', () {
      expect(calculator.multiply(3, 4), 12);
    });

    test('divides two numbers', () {
      expect(calculator.divide(10, 2), 5);
    });

    test('throws an error when dividing by zero', () {
      expect(() => calculator.divide(5, 0), throwsArgumentError);
    });
  });
}
