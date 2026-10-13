import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yum_quick/core/error/failure.dart';
import 'package:yum_quick/features/food/domain/entities/food_item.dart';
import 'package:yum_quick/features/food/domain/repository/food_repository.dart';



part 'food_detail_state.dart';

/// Detail screen state: the item and the chosen quantity.
///
/// The list passes the item it already has, so the screen opens instantly
/// with no extra request. The item is fetched only when it is missing,
/// for example when the screen is opened from a deep link.
class FoodDetailCubit extends Cubit<FoodDetailState> {
  FoodDetailCubit({
    required FoodRepository repository,
    required int id,
    FoodItem? initialItem,
  })  : _repository = repository,
        _id = id,
        super(FoodDetailState(item: initialItem));

  final FoodRepository _repository;
  final int _id;

  static const int maxQuantity = 20;

  /// Loads the item unless it was passed in.
  Future<void> start() async {
    if (state.item == null) {
      await load();
    }
  }

  /// Fetches the item; also used by the retry button.
  Future<void> load() async {
    emit(FoodDetailState(quantity: state.quantity));
    final result = await _repository.getFood(_id);
    emit(
      result.fold(
        (failure) => FoodDetailState(quantity: state.quantity, failure: failure),
        (item) => FoodDetailState(item: item, quantity: state.quantity),
      ),
    );
  }

  void increment() {
    if (state.quantity < maxQuantity) {
      emit(state.copyWith(quantity: state.quantity + 1));
    }
  }

  void decrement() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }
}