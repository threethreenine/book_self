import 'package:hive_flutter/adapters.dart';
import 'package:book_shelf/models/author.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book {
  @HiveField(0)
  final String workId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final List<Author> authors;
  @HiveField(3)
  final String? coverUrl;
  @HiveField(4)
  final int firstPublishedYear;
  @HiveField(5)
  final int editionCount;
  @HiveField(6)
  final List<String> subjects;
  @HiveField(7)
  final List<String> languages;
  @HiveField(8)
  final bool hasFullText;
  @HiveField(9)
  final bool publicScanAvailable;

  Book({
    required this.workId,
    required this.title,
    required this.authors,
    required this.firstPublishedYear,
    required this.editionCount,
    required this.subjects,
    required this.hasFullText,
    required this.publicScanAvailable,
    this.coverUrl,
    required this.languages,
  });

  factory Book.fromSubjectJson(Map<String, dynamic> json) {
    return Book(
      workId: _extractWorkId(json['key']),
      title: json['title'] ?? 'Untitled',
      authors: _parseAuthors(json),
      coverUrl: _buildCoverUrl(json),
      subjects: _parseSubjects(json['subject']),
      editionCount: int.parse(json['edition_count'].toString()) ?? 0,
      firstPublishedYear: int.parse(json['first_publish_year'].toString()) ?? 0,
      hasFullText: bool.parse(json['has_fulltext'].toString())?? false,
      publicScanAvailable: bool.parse(json['public_scan'].toString())?? false,
      languages: [],
    );
  }

  factory Book.fromSearchJson(Map<String, dynamic> json) {
    final authorKeys = (json['author_key'] as List<dynamic>?)?.cast<String>() ?? [];
    final authorNames = (json['author_name'] as List<dynamic>?)?.cast<String>() ?? [];
    final authors = <Author>[];

    for (int i = 0; i < authorKeys.length; i++) {
      if (i < authorNames.length) {
        var author = Author(
          id: authorKeys[i],
          name: authorNames[i],
        );

        author.setPortraitUrl();
        authors.add(author);
      }
    }

    return Book(
      workId: _extractWorkId(json['key']),
      title: json['title'] as String? ?? 'Untitled',
      authors: authors,
      coverUrl: _buildCoverUrl(json),
      subjects: _parseSubjects(json['subject']),
      firstPublishedYear: int.parse(json['first_publish_year'].toString()) ?? 0,
      editionCount: json['edition_count'] as int? ?? 0,
      hasFullText: bool.parse(json['has_fulltext'].toString())?? false,
      publicScanAvailable: bool.parse(json['public_scan_b'].toString())?? false,
      languages: (json['language'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  static String _extractWorkId(String? key) {
    return key?.replaceAll('/works/', '') ?? '';
  }

  static String? _buildCoverUrl(Map<String, dynamic> json) {
    final coverId = json['cover_id'] ?? json['cover_i'] ?? json['cover_edition_key'];
    if (coverId == null) return "https://openlibrary.org/static/images/icons/avatar_book-sm.png";
    return 'https://covers.openlibrary.org/b/id/$coverId-S.jpg';
  }

  static List<String> _parseSubjects(List<dynamic>? subjects) {
    return subjects
        ?.map((s) => s.toString())
        .where((s) => s.isNotEmpty)
        .toList() ?? [];
  }

  static List<Author> _parseAuthors(Map<String, dynamic> json) {
    // 1. /subjects 接口的 authors 对象数组
    if (json['authors'] is List) {
      return (json['authors'] as List)
          .map((a) => Author.fromJson(a))
          .toList();
    }

    // 2. /search 接口的 author_name 字符串数组
    if (json['author_name'] is List) {
      return (json['author_name'] as List)
          .map((name) => Author(
        id: '',
        name: name.toString(),
      ))
          .toList();
    }
    return [];
  }

  Book copyWith({
    String? workId,
    String? title,
    List<Author>? authors,
    String? coverUrl,
    int? firstPublishedYear,
    List<String>? subjects,
    List<String>? languages,
    int? editionCount,
    bool? hasFullText,
    bool? publicScanAvailable,
  }) {
    return Book(
      workId: workId ?? this.workId,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      coverUrl: coverUrl ?? this.coverUrl,
      firstPublishedYear: firstPublishedYear ?? this.firstPublishedYear,
      subjects: subjects ?? this.subjects,
      languages: languages ?? this.languages,
      editionCount: editionCount ?? this.editionCount,
      hasFullText: hasFullText ?? this.hasFullText,
      publicScanAvailable: publicScanAvailable ?? this.publicScanAvailable,
    );
  }
}


Future<Box<Book>> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(AuthorAdapter());
  return await Hive.openBox<Book>('bookshelf');
}
