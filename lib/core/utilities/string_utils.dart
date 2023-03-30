class StringUtils {
  static String removeZeroWidthSpaces(String value) =>
      value.replaceAll('', '\u200B');
}
