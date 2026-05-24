import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import '../services/db_helper.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final DbHelper dbHelper = DbHelper();

  CartCubit() : super(const CartState()) {
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final items = await dbHelper.getCartItems();
    emit(state.copyWith(items: items));
  }

  void addToCart(Product product) async {
    final Map<int, CartItem> updatedItems = Map.from(state.items);
    if (updatedItems.containsKey(product.id)) {
      final existingItem = updatedItems[product.id]!;
      updatedItems[product.id] = existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else {
      updatedItems[product.id] = CartItem(product: product);
    }
    
    await dbHelper.insertOrUpdateCartItem(updatedItems[product.id]!);
    emit(state.copyWith(items: updatedItems));
  }

  void decreaseQuantity(Product product) async {
    final Map<int, CartItem> updatedItems = Map.from(state.items);
    if (updatedItems.containsKey(product.id)) {
      final existingItem = updatedItems[product.id]!;
      if (existingItem.quantity > 1) {
        updatedItems[product.id] = existingItem.copyWith(quantity: existingItem.quantity - 1);
        await dbHelper.insertOrUpdateCartItem(updatedItems[product.id]!);
      } else {
        updatedItems.remove(product.id);
        await dbHelper.deleteCartItem(product.id);
      }
      emit(state.copyWith(items: updatedItems));
    }
  }

  void removeFromCart(Product product) async {
    final Map<int, CartItem> updatedItems = Map.from(state.items);
    updatedItems.remove(product.id);
    await dbHelper.deleteCartItem(product.id);
    emit(state.copyWith(items: updatedItems));
  }
}
