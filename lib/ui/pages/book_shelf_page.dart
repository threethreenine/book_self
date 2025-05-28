import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:book_shelf/models/book.dart';
import 'package:book_shelf/providers/book_shelf_provider.dart';

import 'package:book_shelf/ui/elements/book_list_item.dart';

import 'package:book_shelf/generated/i10n/app_localizations.dart';


class BookShelfPage extends StatelessWidget  {
  const BookShelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myBookshelf),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => context.read<BookshelfProvider>().syncWithServer(),
          ),
        ],
      ),
      body: const BookListView(),
    );
  }
}

class BookListView extends StatelessWidget {
  const BookListView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookshelfProvider>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: provider.searchController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchBookshelfTip,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: provider.repository.watchBooks(),
            builder: (_, __) {
              return provider.filteredBooks.isEmpty ? Center(child: Text(AppLocalizations.of(context)!.noBooksAvailable)) :
              ListView.builder(
                itemCount: provider.filteredBooks.length,
                itemBuilder: (context, index) {

                  final book = provider.filteredBooks[index];
                  return BookListItem(book: book, onLongPress: () => _showDeleteDialog(context, provider, book));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, BookshelfProvider provider, Book book) {
    showDialog(
      context: context, // 必须使用正确的上下文
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmDeletion),
        content: Text("${AppLocalizations.of(context)!.sureDelete} "
            "${AppLocalizations.of(context)!.bookMarkLeft}"
            "${book.title}${AppLocalizations.of(context)!.bookMarkRight}"
            "${AppLocalizations.of(context)!.questionMark}"
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => deleteBook(context, provider, book),
            child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> deleteBook(BuildContext context, BookshelfProvider provider, Book book) async {
    try {
      await provider.removeBook(book.workId);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context); // 确保对话框关闭
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(context)!.deletionFailed}${e.toString()}")),
      );
    }
  }
}
