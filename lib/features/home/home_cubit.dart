import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends Cubit<int> {
  HomeCubit() : super(0);

  void navigateToPage(int index) {
    emit(index);
  }

  void resetValue() {
    emit(0);
  }
}
