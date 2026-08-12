import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/presentation/cubit/food_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodDetailsCubit extends Cubit<FoodDetailsState> {
  FoodDetailsCubit({required FoodModel food})
      : super(FoodDetailsState(food: food));

  void increment() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrement() {
    if (state.quantity <= 1) {
      return;
    }
    emit(state.copyWith(quantity: state.quantity - 1));
  }
}
