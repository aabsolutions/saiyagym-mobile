import 'package:flutter/material.dart';

/// Brand tokens (from the design template). Everything else is derived by
/// Material 3 from [brand], so light and dark stay consistent.
abstract final class AppColors {
  static const brand = Color(0xFF00C9B7);
}

/// Built for the gym: tired, sweaty hands. Large text, 56 dp buttons,
/// generous touch targets, no tiny controls.
abstract final class AppTheme {
  static const fontFamily = 'Outfit';
  static const touchTarget = 56.0;
  static const radius = 14.0;

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: brightness,
      // Keeps the teal recognisable instead of a desaturated tone.
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    final base = ThemeData(
      colorScheme: scheme,
      fontFamily: fontFamily,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
    final text = _textTheme(base.textTheme);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
    const buttonSize = Size(64, touchTarget);
    const buttonPadding = EdgeInsets.symmetric(horizontal: 24);
    final buttonText = text.titleMedium?.copyWith(fontWeight: FontWeight.w600);

    OutlineInputBorder inputBorder([BorderSide side = BorderSide.none]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: side,
        );

    return base.copyWith(
      textTheme: text,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        titleTextStyle: text.headlineSmall?.copyWith(color: scheme.onSurface),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          padding: buttonPadding,
          shape: shape,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          padding: buttonPadding,
          shape: shape,
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          textStyle: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          minimumSize: const Size(0, 52),
          textStyle: text.titleSmall,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: inputBorder(),
        enabledBorder: inputBorder(),
        focusedBorder: inputBorder(BorderSide(color: scheme.primary, width: 2)),
        errorBorder: inputBorder(BorderSide(color: scheme.error)),
        focusedErrorBorder: inputBorder(
          BorderSide(color: scheme.error, width: 2),
        ),
        labelStyle: text.bodyLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius + 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 76,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStatePropertyAll(
          text.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        iconTheme: const WidgetStatePropertyAll(IconThemeData(size: 28)),
      ),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 12,
        titleTextStyle: text.bodyLarge?.copyWith(color: scheme.onSurface),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// One step larger than the M3 defaults: readable at arm's length.
  static TextTheme _textTheme(TextTheme base) => base.copyWith(
    headlineMedium: base.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
    headlineSmall: base.headlineSmall?.copyWith(
      fontSize: 26,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: base.titleMedium?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: base.titleSmall?.copyWith(fontSize: 16),
    bodyLarge: base.bodyLarge?.copyWith(fontSize: 18, height: 1.4),
    bodyMedium: base.bodyMedium?.copyWith(fontSize: 16, height: 1.4),
    labelLarge: base.labelLarge?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: base.labelMedium?.copyWith(fontSize: 14),
  );
}
