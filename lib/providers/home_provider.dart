import 'dart:async';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';

import 'package:book_shelf/models/book.dart';
import 'package:book_shelf/services/book_service.dart';

class HomeProvider with ChangeNotifier {
  final BookService _bookService;

  HomeProvider(this._bookService);

  List<Book> _popularBooks = [];
  List<Book> _searchResults = [];
  List<Book> _newResults = [];
  String? _errorMessage;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isDisposed = false;
  Completer<void>? _initCompleter;
  String _searchQuery = '';
  int _currentPage = 1;


  // Getters
  List<Book> get displayedBooks => _searchQuery.isEmpty ? _popularBooks : _searchResults;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _errorMessage != null;
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;

  Future<void> get initialized {
    _initCompleter ??= Completer();
    return _initCompleter!.future;
  }

  Future<void> fetchPopularBooks() async {
    if (_popularBooks.isNotEmpty) return;

    _resetCompleter();
    _startLoading();

    try {
      final books = await _bookService.fetchPopularBooks();
      if (_isDisposed) return;

      _popularBooks = books;
      _errorMessage = null;
      _safeComplete();
    } catch (e) {

      if (_isDisposed) return;
      _handleError(e);
      _safeCompleteError(e);
    } finally {
      if (!_isDisposed) _endLoading();
      _initCompleter = null;
      safeNotify();
    }
  }

  Future<void> searchBooks(String query) async {
    _searchQuery = query;
    _currentPage = 1;

    if (query.isEmpty) {
      await fetchPopularBooks();
      safeNotify();
      return;
    }

    _startLoading();

    try {
      _searchResults = await _bookService.searchBooks(_searchQuery, _currentPage);
      _errorMessage = null;
    } catch (e) {
      _handleError(e);
    } finally {
      _endLoading();
      safeNotify();
    }
  }

  // 加载更多结果（分页）
  Future<void> loadMoreResults() async {
    if (_isLoadingMore || _searchQuery.isEmpty) return;

    _isLoadingMore = true;
    safeNotify();

    try {
      if (_searchQuery.isNotEmpty){
        _newResults = await _bookService.searchBooks(_searchQuery, ++_currentPage);
      }

      _searchResults.addAll(_newResults);
      _errorMessage = null;
    } catch (e) {
      _currentPage--;
      _handleError(e);
    } finally {
      _isLoadingMore = false;
      safeNotify();
    }
  }

  void _resetCompleter() {
    _initCompleter = null;
  }

  void _safeComplete() {
    if (_initCompleter?.isCompleted == false) {
      _initCompleter?.complete();
    }
  }

  void _safeCompleteError(Object error) {
    if (_initCompleter?.isCompleted == false) {
      _initCompleter?.completeError(error);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _resetCompleter();
    super.dispose();
  }

  void safeNotify() {
    if (_isDisposed) return;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults.clear();
    _newResults.clear();
    _currentPage = 1;
    safeNotify();
    fetchPopularBooks();
  }

  void _startLoading() {
    _isLoading = true;
    _errorMessage = null;
    safeNotify();
  }

  void _endLoading() {
    _isLoading = false;
    safeNotify();
  }

  void _handleError(dynamic error) {
    switch (error) {
      case SocketException _:
      case TimeoutException _:
      case FormatException _:
        _errorMessage = error.message;
        break;
      case BookServiceException _:
        _errorMessage = error.message;
        break;
      case HttpException _:
        _errorMessage = 'Service Error:${error.message}';
        break;
      case TypeError _:
        _errorMessage = 'Data format error';
        break;
      default:
        _errorMessage = 'Loading failed';
    }

    safeNotify();
  }
}