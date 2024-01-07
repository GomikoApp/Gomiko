/// Add any String extension methods here.
extension StringExtension on String {
  /// Returns a copy of this string having its first letter uppercased.
  ///
  /// If this string is empty or already starts with an uppercase letter,
  /// it is returned unchanged.
  ///
  /// Example:
  /// ```dart
  /// void main() {
  ///   print('hello'.capitalize()); // 'Hello'
  ///   print('Hello'.capitalize()); // 'Hello'
  ///   print(''.capitalize()); // ''
  /// }
  /// ```
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
