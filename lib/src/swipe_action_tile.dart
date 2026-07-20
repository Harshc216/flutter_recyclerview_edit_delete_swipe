import 'dart:async';
import 'package:flutter/material.dart';

enum _SwipeAction { edit, delete, archive }

/// A widget that implements swipe-to-edit, swipe-to-delete, and swipe-to-archive actions for list items.
///
/// Wrap your list items (e.g. ListTile, Card) with this widget to enable swipe gestures.
class SwipeActionTile extends StatelessWidget {
  /// The content of the list tile (e.g., a ListTile or Card).
  final Widget child;

  /// Callback triggered when the tile is swiped to Edit.
  ///
  /// If null, the Edit action is disabled.
  final VoidCallback? onEdit;

  /// Callback triggered when the tile is swiped to Delete.
  ///
  /// If null, the Delete action is disabled.
  final VoidCallback? onDelete;

  /// Callback triggered when the tile is swiped to Archive.
  ///
  /// If null, the Archive action is disabled.
  final VoidCallback? onArchive;

  /// An optional callback to confirm before deleting the item.
  ///
  /// If this returns `false`, the delete action is cancelled and the tile slides back.
  /// If this returns `true`, the tile is dismissed and [onDelete] is called.
  final FutureOr<bool> Function()? confirmDelete;

  /// An optional callback to confirm before editing the item.
  ///
  /// Note: Edit actions normally do not dismiss the tile, so even if confirmed,
  /// the tile will slide back to its original position.
  final FutureOr<bool> Function()? confirmEdit;

  /// An optional callback to confirm before archiving the item.
  ///
  /// If this returns `false`, the archive action is cancelled and the tile slides back.
  /// If this returns `true`, the tile is dismissed and [onArchive] is called.
  final FutureOr<bool> Function()? confirmArchive;

  /// Custom background widget for the Edit action.
  ///
  /// If provided, this overrides [editColor], [editIcon], and [editLabel].
  final Widget? editBackground;

  /// Custom background widget for the Delete action.
  ///
  /// If provided, this overrides [deleteColor], [deleteIcon], and [deleteLabel].
  final Widget? deleteBackground;

  /// Custom background widget for the Archive action.
  ///
  /// If provided, this overrides [archiveColor], [archiveIcon], and [archiveLabel].
  final Widget? archiveBackground;

  /// Background color for the Edit action. Defaults to [Colors.blue].
  final Color editColor;

  /// Background color for the Delete action. Defaults to [Colors.red].
  final Color deleteColor;

  /// Background color for the Archive action. Defaults to [Colors.amber].
  final Color archiveColor;

  /// Icon for the Edit action. Defaults to [Icons.edit].
  final IconData editIcon;

  /// Icon for the Delete action. Defaults to [Icons.delete].
  final IconData deleteIcon;

  /// Icon for the Archive action. Defaults to [Icons.archive].
  final IconData archiveIcon;

  /// Text label for the Edit action. Defaults to 'Edit'.
  final String editLabel;

  /// Text label for the Delete action. Defaults to 'Delete'.
  final String deleteLabel;

  /// Text label for the Archive action. Defaults to 'Archive'.
  final String archiveLabel;

  /// Optional preferred direction for the Archive action ([DismissDirection.startToEnd] or [DismissDirection.endToStart]).
  final DismissDirection? archiveDirection;

  /// Color for the icons. Defaults to [Colors.white].
  final Color iconColor;

  /// Color for the text labels. Defaults to [Colors.white].
  final Color textColor;

  /// The border radius applied to the swipe action backgrounds.
  ///
  /// Use this to match the border radius of your card/tile layout.
  final BorderRadius? borderRadius;

  /// Customize the fraction of swipe threshold needed to trigger actions.
  final Map<DismissDirection, double>? swipeThresholds;

  const SwipeActionTile({
    required Key key,
    required this.child,
    this.onEdit,
    this.onDelete,
    this.onArchive,
    this.confirmDelete,
    this.confirmEdit,
    this.confirmArchive,
    this.editBackground,
    this.deleteBackground,
    this.archiveBackground,
    this.editColor = Colors.blue,
    this.deleteColor = Colors.red,
    this.archiveColor = Colors.amber,
    this.editIcon = Icons.edit,
    this.deleteIcon = Icons.delete,
    this.archiveIcon = Icons.archive,
    this.editLabel = 'Edit',
    this.deleteLabel = 'Delete',
    this.archiveLabel = 'Archive',
    this.archiveDirection,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.borderRadius,
    this.swipeThresholds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _SwipeAction? startToEndAction;
    _SwipeAction? endToStartAction;

    if (archiveDirection == DismissDirection.startToEnd) {
      if (onArchive != null) startToEndAction = _SwipeAction.archive;
      if (onDelete != null) endToStartAction = _SwipeAction.delete;
      if (startToEndAction == null && onEdit != null) startToEndAction = _SwipeAction.edit;
    } else if (archiveDirection == DismissDirection.endToStart) {
      if (onEdit != null) startToEndAction = _SwipeAction.edit;
      if (onArchive != null) endToStartAction = _SwipeAction.archive;
      if (endToStartAction == null && onDelete != null) endToStartAction = _SwipeAction.delete;
    } else {
      // Automatic resolution
      if (onEdit != null) {
        startToEndAction = _SwipeAction.edit;
      } else if (onArchive != null) {
        startToEndAction = _SwipeAction.archive;
      }

      if (onDelete != null) {
        endToStartAction = _SwipeAction.delete;
      } else if (onArchive != null && startToEndAction != _SwipeAction.archive) {
        endToStartAction = _SwipeAction.archive;
      }
    }

    final DismissDirection direction;
    if (startToEndAction != null && endToStartAction != null) {
      direction = DismissDirection.horizontal;
    } else if (startToEndAction != null) {
      direction = DismissDirection.startToEnd;
    } else if (endToStartAction != null) {
      direction = DismissDirection.endToStart;
    } else {
      direction = DismissDirection.none;
    }

    if (direction == DismissDirection.none) {
      return child;
    }

    return Dismissible(
      key: key!,
      direction: direction,
      dismissThresholds: swipeThresholds ?? const {},
      background: startToEndAction != null
          ? _buildActionBackground(startToEndAction, isStartAligned: true)
          : const SizedBox.shrink(),
      secondaryBackground: endToStartAction != null
          ? _buildActionBackground(endToStartAction, isStartAligned: false)
          : null,
      confirmDismiss: (dismissDirection) async {
        final action = dismissDirection == DismissDirection.startToEnd
            ? startToEndAction
            : endToStartAction;

        if (action == _SwipeAction.edit) {
          if (confirmEdit != null) {
            final confirm = await confirmEdit!();
            if (confirm) {
              onEdit?.call();
            }
          } else {
            onEdit?.call();
          }
          return false;
        } else if (action == _SwipeAction.delete) {
          if (confirmDelete != null) {
            return await confirmDelete!();
          }
          return true;
        } else if (action == _SwipeAction.archive) {
          if (confirmArchive != null) {
            return await confirmArchive!();
          }
          return true;
        }
        return false;
      },
      onDismissed: (dismissDirection) {
        final action = dismissDirection == DismissDirection.startToEnd
            ? startToEndAction
            : endToStartAction;

        if (action == _SwipeAction.delete) {
          onDelete?.call();
        } else if (action == _SwipeAction.archive) {
          onArchive?.call();
        }
      },
      child: child,
    );
  }

  Widget _buildActionBackground(_SwipeAction action, {required bool isStartAligned}) {
    switch (action) {
      case _SwipeAction.edit:
        if (editBackground != null) return editBackground!;
        return _buildDefaultBackground(
          color: editColor,
          icon: editIcon,
          label: editLabel,
          isStartAligned: isStartAligned,
        );
      case _SwipeAction.delete:
        if (deleteBackground != null) return deleteBackground!;
        return _buildDefaultBackground(
          color: deleteColor,
          icon: deleteIcon,
          label: deleteLabel,
          isStartAligned: isStartAligned,
        );
      case _SwipeAction.archive:
        if (archiveBackground != null) return archiveBackground!;
        return _buildDefaultBackground(
          color: archiveColor,
          icon: archiveIcon,
          label: archiveLabel,
          isStartAligned: isStartAligned,
        );
    }
  }

  Widget _buildDefaultBackground({
    required Color color,
    required IconData icon,
    required String label,
    required bool isStartAligned,
  }) {
    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment:
            isStartAligned ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isStartAligned) ...[
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ] else ...[
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: iconColor, size: 24),
          ],
        ],
      ),
    );

    final container = Container(
      alignment: isStartAligned ? Alignment.centerLeft : Alignment.centerRight,
      color: color,
      child: content,
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: container,
      );
    }

    return container;
  }
}
