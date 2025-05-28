

import 'package:book_shelf/models/author.dart';
import 'package:book_shelf/models/book.dart';
import 'package:book_shelf/repositories/book_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Box<Book> mockBox;
  late BookRepository repository;

  setUp(() async {
    Hive.init('test/tmp');
    Hive.resetAdapters();
    Hive.registerAdapter(BookAdapter());
    Hive.registerAdapter(AuthorAdapter());

    mockBox = await Hive.openBox<Book>('test_books');
    repository = BookRepository(mockBox);
  });

  tearDown(() async {
    // 清空测试数据
    await mockBox.clear();
  });

  tearDownAll(() async {
    // 关闭所有 Box
    await Hive.close();
  });

  test('保存和获取书籍', () async {
    // 准备数据
    final author = Author(id: 'a1', name: '测试作者001');
    author.setPortraitUrl();

    final book = Book(
      workId: 'test_001',
      title: 'Flutter 测试指南',
      authors: [author],
      firstPublishedYear: 1999,
      editionCount: 55,
      subjects: ['test'],
      hasFullText: false,
      publicScanAvailable: true,
      languages: [],
    );

    // 执行保存
    await repository.addBook(book);

    // 验证数据
    final savedBook = await repository.getBook('test_001');
    expect(savedBook, isNotNull);
    expect(savedBook!.title, 'Flutter 测试指南');
    expect(savedBook.authors.first.name, '测试作者001');
  });

  test('删除书籍', () async {
    // 初始化数据
    final book = Book(
        workId: 'test_002',
        title: '待删除书籍',
        authors: [],
        firstPublishedYear: 2000,
        editionCount: 22,
        subjects: ['test'],
        hasFullText: true,
        publicScanAvailable: false,
        languages: []
    );
    await repository.addBook(book);

    // 执行删除
    await repository.removeBook('test_002');

    // 验证结果
    expect(await repository.getBook('test_002'), isNull);
  });

  test('书籍存在性检查', () async {
    // 初始状态验证
    expect(await repository.containsBook('test_003'), false);

    final book = Book(
        workId: 'test_003',
        title: '存在性测试',
        authors: [],
        firstPublishedYear: 2025,
        editionCount: 33,
        subjects: ['test'],
        hasFullText: true,
        publicScanAvailable: false,
        languages: []
    );
    // 添加数据后验证
    await repository.addBook(book);
    expect(await repository.containsBook('test_003'), true);
  });
}