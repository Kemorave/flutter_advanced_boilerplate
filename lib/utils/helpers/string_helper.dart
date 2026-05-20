class StringHelper{
  static String? takeUpToLength(String? text, int length) {
    if (text == null) return null;
    if (text.length <= length) return text;
    return '${text.substring(0, length)}...';
  }
  static String? takeUpToWord(String? text, int length) {
    if (text == null) return null;
    if (text.length <= length) return text;

    final words = text.split(' ');
    return '${words.take(length).join(' ')}...';
  }
}
