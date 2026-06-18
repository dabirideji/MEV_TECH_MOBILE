import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteInitial());
}
