import 'package:yum_quick/core/error/error_gaurd.dart';
import 'package:yum_quick/core/error/result.dart';
import 'package:yum_quick/features/cart/data/data_source/cart_local_data_source.dart';
import 'package:yum_quick/features/cart/data/models/cart_item_model.dart';
import 'package:yum_quick/features/cart/domain/entities/cart_items.dart';
import 'package:yum_quick/features/cart/domain/repository/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({required CartLocalDataSource local}) : _local = local;

  final CartLocalDataSource _local;

  @override
  Future<Result<List<CartItem>>> load() {
    return guard(
      () async => [for (final model in _local.read()) model.toEntity()],
    );
  }

  @override
  Future<Result<void>> save(List<CartItem> items) {
    final models = [for (final item in items) CartItemModel.fromEntity(item)];
    return guard(() => _local.write(models));
  }
}
