/// Formats a price for display, e.g. `$12.99`.
String formatPrice(double value) => '\$${value.toStringAsFixed(2)}';