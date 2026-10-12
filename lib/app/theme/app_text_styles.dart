import 'package:flutter/painting.dart';

/// Text styles from the Figma file.
///
/// The whole design uses League Spartan. The font is bundled in
/// `assets/fonts` instead of fetched at runtime, so it renders correctly
/// on a first launch without network.
abstract final class AppTextStyles {
  static const String fontFamily = 'LeagueSpartan';

  /// "titulo screen": screen titles such as Log In.
  static const TextStyle screenTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1,
  );

  /// Section and panel titles, such as the Cart panel header.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  /// "subtitulo": field labels and subtitles.
  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1,
  );

  /// Pill button labels (Log In, Checkout).
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  /// Filter and category chips.
  static const TextStyle chip = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.085,
  );

  /// "Paragraph": body copy.
  static const TextStyle paragraph = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1,
  );
}
