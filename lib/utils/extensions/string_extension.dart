extension StringExtension on String {
  String toCamelCase() {
    return replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'),
            (match) => (match[0] ?? '').toLowerCase())
        .replaceAll(RegExp(r'\W|_'), ' ')
        .trim()
        .split(' ')
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join('');
  }

  int countWords() {
    return trim().split(' ').length;
  }

  bool validateEmail() {
    return RegExp(r'\w+@\w+\.\w+').hasMatch(this);
  }

  bool validateUrl() {
    return RegExp(
      r'(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?',
      caseSensitive: false,
    ).hasMatch(this);
  }
}
