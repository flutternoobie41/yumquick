import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:yum_quick/features/food/data/models/recipe_model.dart';

/// Offline cache for the first page of the food list, stored in a Hive
/// box as one JSON string.
class FoodLocalDataSource {
  FoodLocalDataSource(this._box);

  final Box<String> _box;

  static const String boxName = 'food_cache';
  static const String _firstPageKey = 'first_page';

  /// The cached first page, or `null` when nothing usable is stored.
  List<RecipeModel>? readFirstPage() {
    final raw = _box.get(_firstPageKey);
    if (raw == null) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) {
        return null;
      }
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(RecipeModel.fromJson)
          .toList();
    } on FormatException {
      return null;
    }
  }

  Future<void> writeFirstPage(List<RecipeModel> recipes) {
    return _box.put(
      _firstPageKey,
      jsonEncode([for (final recipe in recipes) recipe.toJson()]),
    );
  }
}