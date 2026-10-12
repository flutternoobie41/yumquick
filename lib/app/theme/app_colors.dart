import 'package:flutter/painting.dart';

/// Colour tokens from the Figma file's variables.
///
/// Names follow the design file so a value can be matched 1:1 when
/// inspecting a screen in Figma.
abstract final class AppColors {
  /// "Yellow Base": screen headers and the Checkout button.
  static const Color yellowBase = Color(0xFFF5CB58);

  /// "Yellow 2": input field fill.
  static const Color yellow2 = Color(0xFFF3E9B5);

  /// "Orange Base": primary brand colour.
  static const Color orangeBase = Color(0xFFE95322);

  /// "Orange 2": tonal buttons and chips.
  static const Color orange2 = Color(0xFFFFDECF);

  /// "Font": main text colour.
  static const Color font = Color(0xFF391713);

  /// "Font 2": content sheet background and text on orange.
  static const Color font2 = Color(0xFFF8F8F8);

  /// "Text 2": secondary dark text.
  static const Color text2 = Color(0xFF252525);

  /// "White".
  static const Color white = Color(0xFFFFFFFF);

  /// Not in the design file. Error states are ours to design, so this
  /// uses the Material 3 error tone, which sits well next to the oranges.
  static const Color error = Color(0xFFB3261E);
}
