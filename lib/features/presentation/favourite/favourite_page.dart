import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/features/presentation/favourite/cubit/favourite_cubit.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavouriteCubit(),
      child: const Scaffold(
        body: Center(
          child: Text('Favourite Page'),
        ),
      ),
    );
  }
}
