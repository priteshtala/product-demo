import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../home/home_view.dart';
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
      ],
      child: const BottomNavView(),
    );
  }

  const BottomNavView({super.key});

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomCubit, BottomState>(
      builder: (context, state) {
        return Scaffold(
          body: Builder(builder: (context) {
            switch (state.currentIndex) {
              case 0:
                return HomeView.builder(context);
              case 1:
                return const CartView();
              default:
                return const SizedBox();
            }
          }),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<BottomCubit>().changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.production_quantity_limits), label: "Cart"),
            ],
          ),
        );
      },
    );
  }
}
