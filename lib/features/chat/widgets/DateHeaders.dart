import 'package:flutter/material.dart';

class DateHeaders extends StatelessWidget {
  final String dateText;
  DateHeaders({super.key, required this.dateText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            dateText,
            style: theme.textTheme.labelSmall?.copyWith(  // ✅ Theme 텍스트
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ));
  }
}



