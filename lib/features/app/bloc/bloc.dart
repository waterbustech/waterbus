// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:waterbus/core/injection/injection_container.dart';
import 'package:waterbus/features/home/bloc/home/home_bloc.dart';

class AppBloc {
  static final HomeBloc homeBloc = getIt<HomeBloc>();
  static final List<BlocProvider> providers = [
    BlocProvider<HomeBloc>(
      create: (context) => homeBloc,
    ),
  ];

  ///Singleton factory
  static final AppBloc instance = AppBloc._internal();

  factory AppBloc() {
    return instance;
  }

  AppBloc._internal();
}
