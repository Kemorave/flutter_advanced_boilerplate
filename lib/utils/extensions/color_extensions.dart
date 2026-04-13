import 'dart:ui';

extension ColorExtensions on Color {
  /// Returns a new color with the specified opacity (alpha) value,
  /// using the new `withValues` method which avoids precision loss.
  ///
  /// [opacity] should be a normalized value between 0.0 (fully transparent)
  /// and 1.0 (fully opaque).
  Color withOpacityFactor(double opacity) {
    return withValues(alpha: opacity);
  }
}
