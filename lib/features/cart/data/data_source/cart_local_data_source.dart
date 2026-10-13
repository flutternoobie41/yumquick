import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:yum_quick/features/cart/data/models/cart_item_model.dart';

/// Stores the cart in a Hive box as one JSON string. That avoids Hive type
/// adapters and keeps the stored format readable.
class CartLocalDataSource {
  CartLocalDataSource(this._box);

  final Box<String> _box;

  static const String boxName = 'cart';
  static const String _itemsKey = 'items';

  List<CartItemModel> read() {
    final raw = _box.get(_itemsKey);
    if (raw == null) {
      return const [];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) {
        return const [];
      }
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(CartItemModel.fromJson)
          .toList();
    } on FormatException {
      // Unreadable data: start with an empty cart instead of failing.
      return const [];
    }
  }

  Future<void> write(List<CartItemModel> items) {
    return _box.put(
      _itemsKey,
      jsonEncode([for (final item in items) item.toJson()]),
    );
  }
}