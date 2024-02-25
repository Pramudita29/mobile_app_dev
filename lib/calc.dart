// calculator.dart
class Calculator {
  int add(int a, int b) => a + b;
  int subtract(int a, int b) => a - b;
  int multiply(int a, int b) => a * b;
  int divide(int a, int b) {
    if (b == 0) {
      throw ArgumentError('You cannot divide by zero.');
    }
    return a ~/ b;
  }
}
