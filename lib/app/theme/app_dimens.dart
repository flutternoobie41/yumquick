/// Spacing measured on the Figma frames (393 x 852).
abstract final class AppSpacing {
  /// Horizontal page padding. Content is 322 wide on a 393 frame.
  static const double screenHorizontal = 36;
}

/// Corner radii from the Figma components.
abstract final class AppRadius {
  /// Pill buttons such as Log In and Checkout.
  static const double button = 30;

  /// Filter and category chips.
  static const double chip = 38;

  /// Food images and cards.
  static const double card = 20;

  /// Top corners of the light content sheet under the yellow header
  /// (estimated from the frame render; refine when building screens).
  static const double sheet = 30;

    /// Text input fields (estimated from the frame render).
  static const double field = 13;
}
