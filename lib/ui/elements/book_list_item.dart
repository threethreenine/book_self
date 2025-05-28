import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:book_shelf/models/book.dart';
import 'package:cached_network_image/cached_network_image.dart';


class BookListItem extends StatelessWidget {
  final Book book;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  const BookListItem({
    super.key,
    required this.book,
    this.onPressed,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (theme.brightness == Brightness.light)
              BoxShadow(
                color: Colors.black.withAlpha(13), // 0.05
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 1,
              ),
          ],
        ),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(16),
          pressedOpacity: 0.95,
          onPressed: onPressed,
          onLongPress: onLongPress,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBookCover(context),
                // content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMainInfo(context),
                        _buildMetadata(context),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    CupertinoIcons.chevron_forward,
                    size: 16,
                    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookCover(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(
        left: Radius.circular(16),
      ),
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: CupertinoColors.separator.resolveFrom(context),
              width: 0.5,
            ),
          ),
        ),
        child: AspectRatio(
          aspectRatio: 2/3,
          child: book.coverUrl != null
              ? CachedNetworkImage(
            imageUrl: book.coverUrl!,
            fit: BoxFit.cover,
            placeholder: (_, __) => _buildPlaceholder(context),
            errorWidget: (_, __, ___) => _buildPlaceholder(context),
          )
              : _buildPlaceholder(context),
        ),
      ),
    );
  }

  Widget _buildMainInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          book.authors.map((a) => a.name).join(', '),
          style: TextStyle(
            fontSize: 15,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _MetadataChip('${book.firstPublishedYear}', CupertinoIcons.calendar),
        ...book.subjects.take(2).map((subject) => _MetadataChip(subject, CupertinoIcons.tag),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
      child: Center(
        child: Icon(
          CupertinoIcons.book,
          size: 32,
          color: CupertinoColors.tertiaryLabel.resolveFrom(context),
        ),
      ),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  final String text;
  final IconData icon;

  const _MetadataChip(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}

