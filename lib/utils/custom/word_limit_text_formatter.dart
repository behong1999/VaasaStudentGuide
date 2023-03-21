import 'package:flutter/services.dart';

class WordLimitTextInputFormatter extends TextInputFormatter {
  final int _maxWords;

  WordLimitTextInputFormatter(this._maxWords);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (_getWordCount(newValue.text) > _maxWords) {
      return oldValue;
    }
    return newValue;
  }

  int _getWordCount(String text) {
    return text.trim().split(' ').length;
  }
}
