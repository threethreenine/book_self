
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:book_shelf/providers/home_provider.dart';
import 'package:book_shelf/ui/elements/book_list_item.dart';

import 'package:book_shelf/models/book.dart';
import '../../generated/i10n/app_localizations.dart';
import 'book_detail_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _setupScrollListener();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchPopularBooks();
    });
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<HomeProvider>().loadMoreResults();
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();

    _searchDebounce = Timer(Duration(milliseconds: 500), () {
      context.read<HomeProvider>().searchBooks(query);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.searchBooks,
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
            Provider.of<HomeProvider>(context, listen: false).clearSearch();
          },
        ),
      ),
      onChanged: _onSearchChanged,
    );
  }

  Widget _buildContent() {
    final provider = context.watch<HomeProvider>();

    return FutureBuilder(
      future: provider.initialized,
      builder: (context, snapshot) {
        if (provider.isLoading && provider.displayedBooks.isEmpty) {
          return _buildLoading();
        }

        if (provider.hasError) {
          return _buildError(provider.errorMessage);
        }

        if (provider.displayedBooks.isEmpty) {
          return _buildEmptyHint(provider.searchQuery);
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: provider.displayedBooks.length + (provider.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= provider.displayedBooks.length) {
              return _buildLoader();
            }
            final book = provider.displayedBooks[index];
            return BookListItem(book: book, onPressed: ()=> _navigateToDetail(context, book));
          },
        );
      }
    );
  }


  Widget _buildError(String? message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message ?? AppLocalizations.of(context)!.loadingFailure),
          ElevatedButton(
            onPressed: _loadInitialData,
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHint(String query) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          Text(
            query.isEmpty
                ? AppLocalizations.of(context)!.noPopularBooksAvailable
                : '${AppLocalizations.of(context)!.resultNotFound}"$query" ',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildLoader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  void _navigateToDetail(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailPage(book: book),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }
}