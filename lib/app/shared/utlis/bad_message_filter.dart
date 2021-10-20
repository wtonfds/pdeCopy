import 'package:app_pde/app/models/filtered_message.dart';
import 'package:app_pde/app/shared/utlis/bad_words.dart';
import 'package:app_pde/app/shared/utlis/constants.dart';

class BadMessageFilter {
  static FilteredMessage filter(String rawText) {
    int numberCount = 0;

    final numberFreeText = rawText.replaceAll(Constants.badMessageRegex, '*');
    numberCount = '*'.allMatches(numberFreeText).length;
    final wordList = numberFreeText.toLowerCase().split(' ');
    final filteredText = wordList.map((word) {
      if (badWords.contains(word)) {
        return '*' * word.length;
      } else {
        return word;
      }
    }).join(' ');

    return FilteredMessage(
      rawText: rawText,
      text: filteredText,
      hasNumber: numberCount > 0,
      numberCount: numberCount,
    );
  }
}
