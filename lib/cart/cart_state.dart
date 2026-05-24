import 'package:equatable/equatable.dart';
import '../models/product.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}

final class CartState extends Equatable {
  final Map<int, CartItem> items;

  const CartState({this.items = const {}});

  CartState copyWith({Map<int, CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  double get totalPrice => items.values.fold(0, (total, current) => total + (current.product.price * current.quantity));
  
  int get totalItems => items.values.fold(0, (total, current) => total + current.quantity);

  @override
  List<Object?> get props => [items];
}
