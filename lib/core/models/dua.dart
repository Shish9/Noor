class DuaCategory {
  const DuaCategory({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.gradientStartHex,
    required this.gradientEndHex,
  });

  final String id;
  final String name;
  final String subtitle;
  final String icon; // material icon code or asset key
  final String gradientStartHex;
  final String gradientEndHex;
}

class Dua {
  const Dua({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.reference,
    this.audioUrl,
  });

  final String id;
  final String categoryId;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String? reference;
  final String? audioUrl;
}
