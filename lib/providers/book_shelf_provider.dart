import 'package:flutter/cupertino.dart';

import 'package:book_shelf/models/book.dart';
import 'package:book_shelf/repositories/book_repository.dart';

class BookshelfProvider extends ChangeNotifier {
  final BookRepository _repository;
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

  BookshelfProvider(this._repository) {
    searchController.addListener(_handleSearchChange);
  }

  BookRepository get repository => _repository;
  List<Book> get allBooks => _repository.getAllBooks();

  List<Book> get filteredBooks {
    return allBooks.where((book) {
      final query = _searchQuery.toLowerCase();
      return book.title.toLowerCase().contains(query) ||
          book.authors.any((a) => a.name.toLowerCase().contains(query));
    }).toList();
  }

  bool checkBookshelf(String workId){
    return _repository.containsBook(workId);
  }

  void _handleSearchChange() {
    _searchQuery = searchController.text;
    notifyListeners();
  }

  Future<void> removeBook(String workId) async {
    await _repository.removeBook(workId);
    notifyListeners();
  }

  Future<void> saveBook(Book book) async {
    await _repository.addBook(book);
    notifyListeners();
  }

  Future<void> syncWithServer() async {
    // todo
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
