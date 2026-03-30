import 'package:flutter/material.dart';
import '../extensions/context_extension.dart';

class DialogUtils {
  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required String cancelText,
    required VoidCallback onConfirm,
    Color? confirmColor,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(cancelText),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    confirmColor ?? context.colorScheme.primary,
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
