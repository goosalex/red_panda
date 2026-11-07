import 'dart:ui';

/// A category, shown as a little cloud hovering around the panda.
/// Stored in categories.json in the App Group container.
class Category {
  const Category({required this.id, required this.name, required this.color});

  final String id;
  final String name;

  /// Tint of the cloud and the item's category dot.
  final Color color;

  Category copyWith({String? name, Color? color}) =>
      Category(id: id, name: name ?? this.name, color: color ?? this.color);

  factory Category.fromJson(Map<String, dynamic> j) => Category(
        id: j['id'] as String,
        name: j['name'] as String,
        color: Color(j['color'] as int),
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'color': color.toARGB32()};

  /// Soft pastel tints to pick from for new clouds.
  static const palette = [
    Color(0xFF8EC5FF), // sky
    Color(0xFFFFB3C7), // sakura
    Color(0xFFB8E6A6), // matcha
    Color(0xFFFFD98A), // yuzu
    Color(0xFFCDB8FF), // lavender
    Color(0xFFFFC09F), // peach
  ];

  static const maxCount = 6;
}
