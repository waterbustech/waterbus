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
import '../../features/auth/domain/repositories/auth_repository.dart' as _i13;
import '../../features/auth/domain/usecases/check_auth.dart' as _i15;
import '../../features/auth/domain/usecases/login_with_social.dart' as _i17;
import '../../features/auth/domain/usecases/logout.dart' as _i16;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i18;
import '../../features/home/bloc/home/home_bloc.dart' as _i6;
import '../../features/schedule/blocs/schedule/schedule_bloc.dart' as _i9;
import '../utils/datasources/base_remote_data.dart' as _i4;
import '../utils/dio/dio_configuration.dart' as _i5;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i12;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i14;
import '../../features/meeting/data/repositories/meeting_repository_impl.dart'
    as _i8;
import '../../features/meeting/domain/repositories/meeting_repository.dart'
    as _i7;
import '../../features/profile/data/repositories/user_repository_impl.dart'
    as _i11;
import '../../features/profile/domain/repositories/user_repository.dart'
    as _i10;

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
  gh.lazySingleton<_i7.MeetingRepository>(() => _i8.MeetingRepositoryImpl());
  gh.factory<_i9.ScheduleBloc>(() => _i9.ScheduleBloc());
  gh.lazySingleton<_i10.UserRepository>(() => _i11.UserRepositoryImpl());
  gh.lazySingleton<_i12.AuthRemoteDataSource>(
      () => _i12.AuthRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i13.AuthRepository>(() => _i14.AuthRepositoryImpl(
        gh<_i3.AuthLocalDataSource>(),
        gh<_i12.AuthRemoteDataSource>(),
      ));
  gh.factory<_i15.CheckAuth>(() => _i15.CheckAuth(gh<_i13.AuthRepository>()));
  gh.factory<_i16.LogOut>(() => _i16.LogOut(gh<_i13.AuthRepository>()));
  gh.factory<_i17.LoginWithSocial>(
      () => _i17.LoginWithSocial(gh<_i13.AuthRepository>()));
  gh.factory<_i18.AuthBloc>(() => _i18.AuthBloc(
        gh<_i15.CheckAuth>(),
        gh<_i17.LoginWithSocial>(),
        gh<_i16.LogOut>(),
      ));
  return getIt;
}
