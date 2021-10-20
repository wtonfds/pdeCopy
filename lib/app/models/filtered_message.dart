class FilteredMessage {
  final String text;
  final String rawText;
  final bool hasNumber;
  final int numberCount;

  const FilteredMessage({
    required this.rawText,
    required this.text,
    required this.hasNumber,
    required this.numberCount,
  });

  bool get isBad => text != rawText;
}
