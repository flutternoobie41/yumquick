import 'package:yum_quick/core/error/result.dart';
import 'package:yum_quick/features/cart/domain/entities/cart_items.dart';


/// Local cart storage, so the cart survives app restarts.
abstract interface class CartRepository {
  Future<Result<List<CartItem>>> load();

  Future<Result<void>> save(List<CartItem> items);
}