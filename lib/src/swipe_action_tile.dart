import 'dart:async';
import 'package:flutter/material.dart';

/// A widget that implements swipe-to-edit and swipe-to-delete actions for list items.
///
/// Wrap your list items (e.g. ListTile, Card) with this widget to enable swipe gestures.
class SwipeActionTile extends StatelessWidget {
  /// The content of the list tile (e.g., a ListTile or Card).
  final Widget child;

  /// Callback triggered when the tile is swiped to Edit (usually swipe-right).
  ///
  /// If null, the Edit action is disabled.
  final VoidCallback? onEdit;

  /// Callback triggered when the tile is swiped to Delete (usually swipe-left).
  ///
  /// If null, the Delete action is disabled.
  final VoidCallback? onDelete;

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

  /// Custom background widget for the Edit action.
  ///
  /// If provided, this overrides [editColor], [editIcon], and [editLabel].
  final Widget? editBackground;

  /// Custom background widget for the Delete action.
  ///
  /// If provided, this overrides [deleteColor], [deleteIcon], and [deleteLabel].
  final Widget? deleteBackground;

  /// Background color for the Edit action. Defaults to [Colors.blue].
  final Color editColor;

  /// Background color for the Delete action. Defaults to [Colors.red].
  final Color deleteColor;

  /// Icon for the Edit action. Defaults to [Icons.edit].
  final IconData editIcon;

  /// Icon for the Delete action. Defaults to [Icons.delete].
  final IconData deleteIcon;

  /// Text label for the Edit action. Defaults to 'Edit'.
  final String editLabel;

  /// Text label for the Delete action. Defaults to 'Delete'.
  final String deleteLabel;

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
    this.confirmDelete,
    this.confirmEdit,
    this.editBackground,
    this.deleteBackground,
    this.editColor = Colors.blue,
    this.deleteColor = Colors.red,
    this.editIcon = Icons.edit,
    this.deleteIcon = Icons.delete,
    this.editLabel = 'Edit',
    this.deleteLabel = 'Delete',
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.borderRadius,
    this.swipeThresholds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine allowed swipe directions based on callbacks
    final DismissDirection direction;
    if (onEdit != null && onDelete != null) {
      direction = DismissDirection.horizontal;
    } else if (onEdit != null) {
      direction = DismissDirection.startToEnd;
    } else if (onDelete != null) {
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
      background: onEdit != null ? _buildEditBackground() : _buildDeleteBackground(),
      secondaryBackground: onDelete != null ? _buildDeleteBackground() : null,
      confirmDismiss: (dismissDirection) async {
        if (dismissDirection == DismissDirection.startToEnd) {
          // Swipe Right: Edit
          if (confirmEdit != null) {
            final confirm = await confirmEdit!();
            if (confirm) {
              onEdit?.call();
            }
          } else {
            onEdit?.call();
          }
          // Returning false ensures the tile slides back to its original position
          return false;
        } else if (dismissDirection == DismissDirection.endToStart) {
          // Swipe Left: Delete
          if (confirmDelete != null) {
            final confirm = await confirmDelete!();
            if (confirm) {
              onDelete?.call();
              return true;
            }
            return false;
          } else {
            onDelete?.call();
            return true;
          }
        }
        return false;
      },
      child: child,
    );
  }

  Widget _buildEditBackground() {
    if (editBackground != null) return editBackground!;

    return _buildDefaultBackground(
      color: editColor,
      icon: editIcon,
      label: editLabel,
      isStartAligned: true,
    );
  }

  Widget _buildDeleteBackground() {
    if (deleteBackground != null) return deleteBackground!;

    return _buildDefaultBackground(
      color: deleteColor,
      icon: deleteIcon,
      label: deleteLabel,
      isStartAligned: false,
    );
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
