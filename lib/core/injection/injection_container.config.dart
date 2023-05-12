// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/auth/data/datasources/auth_local_datasource.dart' as _i3;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i7;
import '../../features/auth/data/repositories/auth_repository_impl.dart' as _i9;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i8;
import '../../features/auth/domain/usecases/check_auth.dart' as _i10;
import '../../features/auth/domain/usecases/login_with_social.dart' as _i11;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i12;
import '../../features/home/bloc/home/home_bloc.dart' as _i5;
import '../../features/schedule/blocs/schedule/schedule_bloc.dart' as _i6;
import '../utils/datasources/base_remote_data.dart' as _i4;

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
  gh.singleton<_i4.BaseRemoteData>(_i4.BaseRemoteData());
  gh.factory<_i5.HomeBloc>(() => _i5.HomeBloc());
  gh.factory<_i6.ScheduleBloc>(() => _i6.ScheduleBloc());
  gh.lazySingleton<_i7.AuthRemoteDataSource>(
      () => _i7.AuthRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i8.AuthRepository>(() => _i9.AuthRepositoryImpl(
        gh<_i3.AuthLocalDataSource>(),
        gh<_i7.AuthRemoteDataSource>(),
      ));
  gh.factory<_i10.CheckAuth>(() => _i10.CheckAuth(gh<_i8.AuthRepository>()));
  gh.factory<_i11.LoginWithSocial>(
      () => _i11.LoginWithSocial(gh<_i8.AuthRepository>()));
  gh.factory<_i12.AuthBloc>(() => _i12.AuthBloc(
        gh<_i10.CheckAuth>(),
        gh<_i11.LoginWithSocial>(),
      ));
  return getIt;
}
