// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

// Package imports:
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

// Project imports:
import '../../features/auth/data/datasources/auth_local_datasource.dart' as _i3;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i12;
import '../../features/auth/domain/usecases/check_auth.dart' as _i14;
import '../../features/auth/domain/usecases/login_with_social.dart' as _i16;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i18;
import '../../features/home/bloc/home/home_bloc.dart' as _i6;
import '../../features/profile/domain/repositories/user_repository.dart' as _i9;
import '../../features/profile/domain/usecases/get_user_profile.dart' as _i15;
import '../../features/schedule/blocs/schedule/schedule_bloc.dart' as _i7;
import '../utils/datasources/base_remote_data.dart' as _i4;
import '../utils/dio/dio_configuration.dart' as _i5;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i11;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i13;
import '../../features/profile/data/datasources/user_remote_datasource.dart'
    as _i8;
import '../../features/profile/data/repositories/user_repository_impl.dart'
    as _i10;
import '../../features/profile/domain/usecases/update_user_profile.dart'
    as _i17;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i3.AuthLocalDataSource>(
      () => _i3.AuthLocalDataSourceImpl());
  gh.singleton<_i4.BaseRemoteData>(
      _i4.BaseRemoteData(gh<_i3.AuthLocalDataSource>()));
  gh.singleton<_i5.DioConfiguration>(_i5.DioConfiguration(
    gh<_i4.BaseRemoteData>(),
    gh<_i3.AuthLocalDataSource>(),
  ));
  gh.factory<_i6.HomeBloc>(() => _i6.HomeBloc());
  gh.factory<_i7.ScheduleBloc>(() => _i7.ScheduleBloc());
  gh.lazySingleton<_i8.UserRemoteDataSource>(
      () => _i8.UserRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i9.UserRepository>(
      () => _i10.UserRepositoryImpl(gh<_i8.UserRemoteDataSource>()));
  gh.lazySingleton<_i11.AuthRemoteDataSource>(
      () => _i11.AuthRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i12.AuthRepository>(() => _i13.AuthRepositoryImpl(
        gh<_i3.AuthLocalDataSource>(),
        gh<_i11.AuthRemoteDataSource>(),
      ));
  gh.factory<_i14.CheckAuth>(() => _i14.CheckAuth(gh<_i12.AuthRepository>()));
  gh.factory<_i15.GetUserProfile>(
      () => _i15.GetUserProfile(gh<_i9.UserRepository>()));
  gh.factory<_i16.LoginWithSocial>(
      () => _i16.LoginWithSocial(gh<_i12.AuthRepository>()));
  gh.factory<_i17.UpdateUserProfile>(
      () => _i17.UpdateUserProfile(gh<_i9.UserRepository>()));
  gh.factory<_i18.AuthBloc>(() => _i18.AuthBloc(
        gh<_i14.CheckAuth>(),
        gh<_i16.LoginWithSocial>(),
      ));
  return getIt;
}
