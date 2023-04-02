class StringUtils {
  static String removeZeroWidthSpaces(String value) =>
      value.replaceAll('', '\u200B');

  static String replaceUnderscoreToSpaceAndTitleCase(String value) {
    final String withoutUnderscores = value.replaceAll('_', ' ');
    final List<String> words = withoutUnderscores.split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
    }
    return words.join(' ');
  }

  static bool isStringDifferent(String oldData, String newData) {
    return oldData != newData;
  }

  static String capitalize(String data) {
    return "${data[0].toUpperCase()}${data.substring(1).toLowerCase()}";
  }
}
