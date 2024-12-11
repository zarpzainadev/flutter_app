// lib/components/generic_list_widget.dart
import 'package:flutter/material.dart';

class GenericListWidget<T> extends StatefulWidget {
  final List<T> items;
  final List<GenericAction<T>> actions;
  final bool isLoading;
  final String emptyMessage;
  final IconData emptyIcon;
  final String Function(T) getTitle;
  final String Function(T) getSubtitle;
  final List<ChipInfo> Function(T)? getChips;
  final String Function(T)? getAvatarText;
  final Widget Function(T)? getAvatarWidget;

  const GenericListWidget({
    Key? key,
    required this.items,
    required this.actions,
    required this.getTitle,
    required this.getSubtitle,
    this.isLoading = false,
    this.emptyMessage = 'No hay elementos',
    this.emptyIcon = Icons.inbox_outlined,
    this.getChips,
    this.getAvatarText,
    this.getAvatarWidget,
  }) : super(key: key);

  @override
  State<GenericListWidget<T>> createState() => _GenericListWidgetState<T>();
}

class GenericAction<T> {
  final IconData icon;
  final Color color;
  final String tooltip;
  final Function(T) onPressed;
  final bool Function(T)? isVisible;
  final Color Function(T)? getColor;
  final String Function(T)? getTooltip;

  const GenericAction({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
    this.isVisible,
    this.getColor,
    this.getTooltip,
  });
}

class ChipInfo {
  final IconData icon;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final double? maxWidth;
  final int? maxLines;

  const ChipInfo({
    required this.icon,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.maxWidth,
    this.maxLines,
  });
}

class _GenericListWidgetState<T> extends State<GenericListWidget<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.emptyIcon, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              widget.emptyMessage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: widget.getAvatarWidget?.call(item) ??
                  (widget.getAvatarText != null
                      ? CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            widget.getAvatarText!(item),
                            style: const TextStyle(
                              color: Color(0xFF1E3A8A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null),
              title: Text(
                widget.getTitle(item),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                widget.getSubtitle(item),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.getChips != null) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.getChips!(item)
                              .map((chip) => _buildInfoChip(
                                    chip.icon,
                                    chip.label,
                                    chip.backgroundColor,
                                    chip.textColor,
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: widget.actions
                            .where((action) =>
                                action.isVisible == null ||
                                action.isVisible!(item))
                            .map((action) => Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: IconButton(
                                    icon: Icon(action.icon),
                                    color: action.getColor?.call(item) ??
                                        action.color,
                                    tooltip: action.getTooltip?.call(item) ??
                                        action.tooltip,
                                    onPressed: () => action.onPressed(item),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(
      IconData icon, String label, Color? backgroundColor, Color? textColor,
      {double? maxWidth, int? maxLines}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth) : null,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor ?? Colors.grey[600]),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: textColor ?? Colors.grey[600],
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines ?? 1,
            ),
          ),
        ],
      ),
    );
  }
}
