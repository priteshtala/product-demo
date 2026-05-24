part of 'home_view.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApiService apiService;

  HomeCubit(this.apiService) : super(HomeInitial());

  Future<void> fetchProducts() async {
    emit(HomeLoading());
    try {
      final products = await apiService.fetchProducts();
      emit(HomeLoaded(products));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
