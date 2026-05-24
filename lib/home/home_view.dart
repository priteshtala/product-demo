import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../cart/cart_cubit.dart';
import 'favorite_cubit.dart';

part 'home_view_cubit.dart';
part 'home_view_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static String routeName = "/home";

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(ApiService())..fetchProducts(),
      child: const HomeView(),
    );
  }

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Card(
                  elevation: 3,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/details', arguments: product);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(product.image, fit: BoxFit.contain),
                                Positioned(
                                  top: -10,
                                  right: -10,
                                  child: BlocBuilder<FavoriteCubit, Set<int>>(
                                    builder: (context, favorites) {
                                      final isLiked = favorites.contains(product.id);
                                      return IconButton(
                                        icon: Icon(
                                          isLiked ? Icons.favorite : Icons.favorite_border,
                                          color: isLiked ? Colors.red : Colors.grey,
                                        ),
                                        onPressed: () {
                                          context.read<FavoriteCubit>().toggleFavorite(product.id);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('\$${product.price}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<CartCubit>().addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${product.title} added to cart'), duration: const Duration(seconds: 1))
                              );
                            },
                            child: const Text('Add to Cart'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is HomeError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
