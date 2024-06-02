// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i13;
import '../../features/home/bloc/home/home_bloc.dart' as _i5;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i3;
import '../../features/settings/lang/datasource/lang_datasource.dart' as _i10;
import '../../features/settings/themes/bloc/themes_bloc.dart' as _i12;
import '../../features/settings/themes/data/themes_datasource.dart' as _i9;
import '../method_channels/pip_channel.dart' as _i6;

import '../../features/chats/xmodels/datasources/user_local_datasource.dart'
    as _i11;
import '../../features/meeting/data/datasources/call_settings_datasource.dart'
    as _i8;
import '../../features/meeting/data/datasources/meeting_local_datasource.dart'
    as _i7;
import '../../features/meeting/presentation/bloc/beauty_filters/beauty_filters_bloc.dart'
    as _i4;
import '../../features/meeting/presentation/bloc/meeting/meeting_bloc.dart'
    as _i14;
import '../../features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart'
    as _i15;

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
  gh.factory<_i3.UserBloc>(() => _i3.UserBloc());
  gh.factory<_i4.BeautyFiltersBloc>(() => _i4.BeautyFiltersBloc());
  gh.factory<_i5.HomeBloc>(() => _i5.HomeBloc());
  gh.singleton<_i6.PipChannel>(() => _i6.PipChannel());
  gh.lazySingleton<_i7.MeetingLocalDataSource>(
      () => _i7.MeetingLocalDataSourceImpl());
  gh.lazySingleton<_i8.CallSettingsLocalDataSource>(
      () => _i8.CallSettingsLocalDataSourceImpl());
  gh.lazySingleton<_i9.ThemesDatasource>(() => _i9.ThemesDatasourceImpl());
  gh.lazySingleton<_i10.LanguagesDatasource>(
      () => _i10.LanguagesDatasourceImpl());
  gh.lazySingleton<_i11.UserLocalDataSource>(
      () => _i11.UserLocalDataSourceImpl());
  gh.factory<_i12.ThemesBloc>(
      () => _i12.ThemesBloc(gh<_i9.ThemesDatasource>()));
  gh.factory<_i13.AuthBloc>(
      () => _i13.AuthBloc(gh<_i11.UserLocalDataSource>()));
  gh.factory<_i14.MeetingBloc>(() => _i14.MeetingBloc(
        gh<_i6.PipChannel>(),
        gh<_i7.MeetingLocalDataSource>(),
        gh<_i8.CallSettingsLocalDataSource>(),
      ));
  gh.factory<_i15.RecentJoinedBloc>(
      () => _i15.RecentJoinedBloc(gh<_i7.MeetingLocalDataSource>()));
  return getIt;
}
