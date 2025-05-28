
import 'dart:async';
import 'dart:convert';
import 'package:universal_io/io.dart';

import 'package:book_shelf/services/proxy_manager.dart';
import 'package:book_shelf/models/book.dart';

class BookService {
  static const _baseUrl = 'https://openlibrary.org';

  final ProxyManager proxyManager;

  BookService(this.proxyManager);

  Future<List<Book>> fetchPopularBooks() async {
    final client = proxyManager.createProxiedClient();

    try {
      final request = await client.getUrl(Uri.parse('$_baseUrl/subjects/popular.json'));
      final response = await request.close();

      _checkServiceError(response);

      String? responseBody = await response.transform(utf8.decoder).join();
      return _parseSubjectResponse(responseBody);
    } catch (e) {
      throw _handleError(e);
    } finally {
      client.close(force: true);
    }
  }

  List<Book> _parseSubjectResponse(String responseBody) {
    final json = jsonDecode(responseBody);
    final works = json['works'] as List? ?? [];
    return works.map((work) => Book.fromSubjectJson(work)).toList();
  }

  Future<List<Book>> searchBooks(String query, int page) async {
    final client = proxyManager.createProxiedClient();

    try{
      final request = await client.getUrl(Uri.parse('$_baseUrl/search.json?q=$query&page=$page?limit=10'));
      final response = await request.close();

      _checkServiceError(response);

      String? responseBody = await response.transform(utf8.decoder).join();
      return _parseBooks(responseBody);
    } catch (e) {
      throw _handleError(e);
    } finally {
      client.close(force: true);
    }
  }

  List<Book> _parseBooks(String responseBody) {
    final json = jsonDecode(responseBody);
    final docs = json['docs'] as List? ?? [];
    return docs.map((doc) => Book.fromSearchJson(doc)).toList();
  }

  void _checkServiceError(HttpClientResponse response){
    if (response.statusCode != 200) {
      throw BookServiceException(
        message: '"Service Error',
        statusCode: response.statusCode,
      );
    }
  }

  BookServiceException _handleError(dynamic error) {
    if (error is SocketException) {
      return BookServiceException(
        message: 'Network connection failed, please check network settings',
        error: error,
      );
    } else if (error is TimeoutException) {
      return BookServiceException(
        message: 'Request timed out, please retry',
        error: error,
      );
    } else if (error is FormatException) {
      return BookServiceException(
        message: 'Data parsing failed',
        error: error,
      );
    } else if (error is BookServiceException) {
      return error;
    } else {
      return BookServiceException(
        message: 'Unknown error: ${error.runtimeType}',
        error: error,
      );
    }
  }
}

class BookServiceException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  const BookServiceException({
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  String toString() => 'BookServiceException: $message (code: $statusCode)';
}