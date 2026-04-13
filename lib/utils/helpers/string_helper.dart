class StringHelper{
  static String? takeUpToLength(String? text, int length) {
    if (text == null) return null;
    if (text.length <= length) return text;
    return '${text.substring(0, length)}...';
  }
  static String? takeUpToWord(String? text, int length) {
    if (text == null) return null;
    if (text.length <= length) return text;
    final lastSpace = text.lastIndexOf(' ', length);
    if (lastSpace == -1) return '${text.substring(0, length)}...';
    return '${text.substring(0, lastSpace)}...';
  }
}
