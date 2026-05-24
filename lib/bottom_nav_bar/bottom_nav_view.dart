import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../home/home_view.dart';
import '../home/product_details_view.dart';
import '../home/favorite_cubit.dart';
import '../models/product.dart';
import '../cart/cart_cubit.dart';
import '../cart/cart_view.dart';

part 'bottom_cubit.dart';
part 'bottom_state.dart';

class BottomNavView extends StatefulWidget {
  static String routeName = "/";

  static Widget builder(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => FavoriteCubit()),
      ],
      child: const BottomNavView(),
    );
  }

  const BottomNavView({super.key});

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomCubit, BottomState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: [
              Navigator(
                key: _homeNavigatorKey,
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                    builder: (context) {
                      if (settings.name == '/details') {
                        final product = settings.arguments as Product;
                        return ProductDetailsView(product: product);
                      }
                      return HomeView.builder(context);
                    },
                  );
                },
              ),
              const CartView(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              if (state.currentIndex == index && index == 0) {
                 _homeNavigatorKey.currentState?.popUntil((route) => route.isFirst);
              } else {
                 context.read<BottomCubit>().changeIndex(index);
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
            ],
          ),
        );
      },
    );
  }
}
