import 'package:hive_flutter/adapters.dart';

part 'author.g.dart';

@HiveType(typeId: 1)
class Author {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? portraitUrl;

  const Author({
    required this.id,
    required this.name,
    this.portraitUrl,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    final id = _parseAuthorId(json['key']);
    return Author(
      id: id,
      name: _parseAuthorName(json),
      portraitUrl: _buildPortraitUrl(id),
    );
  }

  static String _parseAuthorId(dynamic key) {
    if (key is! String) return '';
    return key.replaceAll('/authors/', '');
  }

  static String _parseAuthorName(Map<String, dynamic> json) {
    return json['name']?.toString().trim() ?? 'Unknown Author';
  }

  static String? _buildPortraitUrl(String id) {
    if (id.isEmpty) return "https://openlibrary.org/static/images/icons/avatar_author-lg.png";
    return 'https://covers.openlibrary.org/a/olid/$id-S.jpg';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Author &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Author{id: $id, name: $name}';
  }

  void setPortraitUrl(){
    if(portraitUrl == null){
      Author._parseAuthorId(id);
    }
  }
}