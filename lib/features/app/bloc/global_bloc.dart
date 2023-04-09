// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBloc {
  static final List<BlocProvider> providers = [];

  ///Singleton factory
  static final GlobalBloc instance = GlobalBloc._internal();

  factory GlobalBloc() {
    return instance;
  }

  GlobalBloc._internal();
}
