// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i14;
import '../../features/chats/presentation/bloc/chat_bloc.dart' as _i6;
import '../../features/home/bloc/home/home_bloc.dart' as _i3;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i5;
import '../../features/settings/lang/datasource/lang_datasource.dart' as _i11;
import '../../features/settings/themes/bloc/themes_bloc.dart' as _i13;
import '../../features/settings/themes/data/themes_datasource.dart' as _i10;
import '../method_channels/pip_channel.dart' as _i7;

import '../../features/chats/data/datasources/user_local_datasource.dart'
    as _i12;
import '../../features/meeting/data/datasources/call_settings_datasource.dart'
    as _i9;
import '../../features/meeting/data/datasources/meeting_local_datasource.dart'
    as _i8;
import '../../features/meeting/presentation/bloc/beauty_filters/beauty_filters_bloc.dart'
    as _i4;
import '../../features/meeting/presentation/bloc/meeting/meeting_bloc.dart'
    as _i15;
import '../../features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart'
    as _i16;

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
  gh.factory<_i3.HomeBloc>(() => _i3.HomeBloc());
  gh.factory<_i4.BeautyFiltersBloc>(() => _i4.BeautyFiltersBloc());
  gh.factory<_i5.UserBloc>(() => _i5.UserBloc());
  gh.factory<_i6.ChatBloc>(() => _i6.ChatBloc());
  gh.singleton<_i7.PipChannel>(() => _i7.PipChannel());
  gh.lazySingleton<_i8.MeetingLocalDataSource>(
      () => _i8.MeetingLocalDataSourceImpl());
  gh.lazySingleton<_i9.CallSettingsLocalDataSource>(
      () => _i9.CallSettingsLocalDataSourceImpl());
  gh.lazySingleton<_i10.ThemesDatasource>(() => _i10.ThemesDatasourceImpl());
  gh.lazySingleton<_i11.LanguagesDatasource>(
      () => _i11.LanguagesDatasourceImpl());
  gh.lazySingleton<_i12.UserLocalDataSource>(
      () => _i12.UserLocalDataSourceImpl());
  gh.factory<_i13.ThemesBloc>(
      () => _i13.ThemesBloc(gh<_i10.ThemesDatasource>()));
  gh.factory<_i14.AuthBloc>(
      () => _i14.AuthBloc(gh<_i12.UserLocalDataSource>()));
  gh.factory<_i15.MeetingBloc>(() => _i15.MeetingBloc(
        gh<_i7.PipChannel>(),
        gh<_i8.MeetingLocalDataSource>(),
        gh<_i9.CallSettingsLocalDataSource>(),
      ));
  gh.factory<_i16.RecentJoinedBloc>(
      () => _i16.RecentJoinedBloc(gh<_i8.MeetingLocalDataSource>()));
  return getIt;
}
