/// One dhikr (remembrance) phrase with its target count and meta.
class Dhikr {
  const Dhikr({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.target,
    required this.virtue,
    this.colorHex = '#10B981',
  });

  final String id;
  final String arabic;
  final String transliteration;
  final String translation;

  /// Target count. `0` = unlimited (just keep counting).
  final int target;

  /// Brief virtue/reward note shown under the phrase.
  final String virtue;

  /// Accent color (gradient base) for the card.
  final String colorHex;

  bool get isUnlimited => target == 0;
}
