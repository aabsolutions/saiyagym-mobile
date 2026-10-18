import 'package:flutter/material.dart';

/// Full-width filled button with a built-in loading state (disabled while
/// loading, so a double tap can't submit twice).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              )
            : Text(label),
      ),
    );
  }
}
