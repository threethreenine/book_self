import 'package:hive/hive.dart';
import 'package:book_shelf/models/book.dart';

class BookRepository {
  final Box<Book> _box;
  BookRepository(this._box);

  Future<void> addBook(Book book) async {
    await _box.put(book.workId, book);
  }

  Future<void> removeBook(String workId) async {
    await _box.delete(workId);
  }

  Future<Book?> getBook(String workId) async {
    return _box.get(workId);
  }

  List<Book> getAllBooks() => _box.values.toList();

  List<Book> filterBooks({String? filter}) {
    final books = _box.values.toList();
    if (filter == null || filter.isEmpty) return books;

    return books.where((book) {
      return book.title.toLowerCase().contains(filter.toLowerCase()) ||
          book.authors.any((author) => author.name.toLowerCase().contains(filter.toLowerCase()));
    }).toList();
  }

  bool containsBook(String workId){
    return _box.containsKey(workId);
  }

  Stream<BoxEvent> watchBooks() => _box.watch();

  // 关闭资源
  Future<void> close() async {
    await _box.close();
  }

  Future<void> syncWithRemote() async {
    // todo
  }
}