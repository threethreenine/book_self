import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:book_shelf/models/author.dart';
import 'package:book_shelf/models/book.dart';
import 'package:book_shelf/providers/book_shelf_provider.dart';

import 'package:book_shelf/generated/i10n/app_localizations.dart';


class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage>{
  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    final provider = context.watch<BookshelfProvider>();
    final isInBookshelf = provider.checkBookshelf(book.workId);

    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(book),
            const SizedBox(height: 24),
            _buildInfoSection(book),
            const SizedBox(height: 24),
            _buildActionButton(isInBookshelf),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(Book book) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCoverImage(book),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              _buildAuthorList(book.authors),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.firstPublished} ${book.firstPublishedYear} ${AppLocalizations.of(context)!.year}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoverImage(Book book) {
    return SizedBox(
      width: 120,
      height: 180,
      child: book.coverUrl != null
          ? CachedNetworkImage(
        imageUrl: book.coverUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) => _PlaceholderCover(),
        errorWidget: (_, __, ___) => _PlaceholderCover(),
      )
          : _PlaceholderCover(),
    );
  }

  Widget _buildAuthorList(List<Author> authors) {
    return Text(
      authors.map((a) => a.name).join('、'),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.grey[600],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfoSection(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (book.subjects.isNotEmpty) ...[
          Text(AppLocalizations.of(context)!.subjectClassification, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: book.subjects
                .map((subject) => Chip(
              label: Text(subject),
              visualDensity: VisualDensity.compact,
            ))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (book.languages.isNotEmpty) ...[
          Text(AppLocalizations.of(context)!.language, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: book.languages.map((subject) => Chip(
              label: Text(subject),
              visualDensity: VisualDensity.compact,
            ))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(bool isInBookshelf) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 200),
      builder: (_, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: _buildThemedButton(isInBookshelf),
    );
  }

  Widget _buildThemedButton(bool isInBookshelf) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: Icon(
              isInBookshelf ? Icons.remove : Icons.add,
              key: ValueKey(isInBookshelf), // 强制重建实现动画
            ),
          ),
          label: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: textTheme.labelLarge!.copyWith(
              color: isInBookshelf
                  ? colorScheme.onErrorContainer
                  : colorScheme.onPrimaryContainer,
            ),
            child: Text(isInBookshelf ? AppLocalizations.of(context)!.removeFromBookshelf : AppLocalizations.of(context)!.addToBookshelf),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isInBookshelf
                ? colorScheme.errorContainer
                : colorScheme.primaryContainer,
            foregroundColor: isInBookshelf
                ? colorScheme.onErrorContainer
                : colorScheme.onPrimaryContainer,
            elevation: 4,
            shadowColor: colorScheme.shadow,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            animationDuration: const Duration(milliseconds: 300),
          ),
          onPressed: () => _handleBookshelfAction(isInBookshelf),
        ),
      ),
    );
  }

  void _handleBookshelfAction(bool isInBookshelf) async {

    final provider = Provider.of<BookshelfProvider>(context, listen: false);
    if (isInBookshelf) {
      await provider.removeBook(widget.book.workId);
    } else {
      await provider.saveBook(widget.book);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isInBookshelf ? AppLocalizations.of(context)!.removedFromBookshelf : AppLocalizations.of(context)!.addedToBookshelf)),
    );
  }
}

class _PlaceholderCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 102,
      color: Colors.grey[200],
      child: Icon(Icons.book, color: Colors.grey[500]),
    );
  }
}