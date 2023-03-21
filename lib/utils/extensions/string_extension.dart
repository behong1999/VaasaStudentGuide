extension CamelCaseExtension on String {
  String toCamelCase() {
    return replaceAllMapped(
            RegExp(r'(?<=[a-z])[A-Z]'), (match) => match[0]!.toLowerCase())
        .replaceAll(RegExp(r'\W|_'), ' ')
        .trim()
        .split(' ')
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join('');
  }
}

extension WordCountExtension on String {
  int countWords() {
    return trim().split(' ').length;
  }
}
