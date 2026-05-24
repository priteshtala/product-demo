import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/db_helper.dart';

class FavoriteCubit extends Cubit<Set<int>> {
  final DbHelper dbHelper = DbHelper();

  FavoriteCubit() : super(const {}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await dbHelper.getFavorites();
    emit(favorites);
  }

  void toggleFavorite(int productId) async {
    final Set<int> newFavorites = Set.from(state);
    final bool isLiked = newFavorites.contains(productId);
    
    if (isLiked) {
      newFavorites.remove(productId);
      await dbHelper.toggleFavorite(productId, false);
    } else {
      newFavorites.add(productId);
      await dbHelper.toggleFavorite(productId, true);
    }
    
    emit(newFavorites);
  }
}
