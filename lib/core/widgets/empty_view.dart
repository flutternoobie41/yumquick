import 'package:flutter/material.dart';
import 'package:yum_quick/core/widgets/status_view.dart';

/// Friendly empty state, e.g. an empty cart or a search with no results.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.restaurant_menu_rounded,
    this.action,
  });

  final String title;
  final String? message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return StatusView(
      icon: icon,
      title: title,
      message: message,
      action: action,
    );
  }
}