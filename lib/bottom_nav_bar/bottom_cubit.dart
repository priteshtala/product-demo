part of 'bottom_nav_view.dart';

class BottomCubit extends Cubit<BottomState> {
  BottomCubit() : super(const BottomState());

  void changeIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
