// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i17;
import '../../features/chats/presentation/bloc/chat_bloc.dart' as _i6;
import '../../features/conversation/bloc/message_bloc.dart' as _i7;
import '../../features/conversation/socket/socket_chat_handle.dart' as _i13;
import '../../features/home/bloc/home/home_bloc.dart' as _i3;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i5;
import '../../features/settings/lang/datasource/lang_datasource.dart' as _i12;
import '../../features/settings/themes/bloc/themes_bloc.dart' as _i16;
import '../../features/settings/themes/data/themes_datasource.dart' as _i11;
import '../method_channels/pip_channel.dart' as _i8;

import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart'
    as _i14;

import '../../features/chats/data/datasources/user_local_datasource.dart'
    as _i15;
import '../../features/meeting/data/datasources/call_settings_datasource.dart'
    as _i10;
import '../../features/meeting/data/datasources/meeting_local_datasource.dart'
    as _i9;
import '../../features/meeting/presentation/bloc/beauty_filters/beauty_filters_bloc.dart'
    as _i4;
import '../../features/meeting/presentation/bloc/meeting/meeting_bloc.dart'
    as _i18;
import '../../features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart'
    as _i19;

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
  gh.factory<_i7.MessageBloc>(() => _i7.MessageBloc());
  gh.singleton<_i8.PipChannel>(() => _i8.PipChannel());
  gh.lazySingleton<_i9.MeetingLocalDataSource>(
      () => _i9.MeetingLocalDataSourceImpl());
  gh.lazySingleton<_i10.CallSettingsLocalDataSource>(
      () => _i10.CallSettingsLocalDataSourceImpl());
  gh.lazySingleton<_i11.ThemesDatasource>(() => _i11.ThemesDatasourceImpl());
  gh.lazySingleton<_i12.LanguagesDatasource>(
      () => _i12.LanguagesDatasourceImpl());
  gh.factory<_i13.SocketChatHandle>(
      () => _i13.SocketChatHandle(gh<_i14.SocketHandler>()));
  gh.lazySingleton<_i15.UserLocalDataSource>(
      () => _i15.UserLocalDataSourceImpl());
  gh.factory<_i16.ThemesBloc>(
      () => _i16.ThemesBloc(gh<_i11.ThemesDatasource>()));
  gh.factory<_i17.AuthBloc>(
      () => _i17.AuthBloc(gh<_i15.UserLocalDataSource>()));
  gh.factory<_i18.MeetingBloc>(() => _i18.MeetingBloc(
        gh<_i8.PipChannel>(),
        gh<_i9.MeetingLocalDataSource>(),
        gh<_i10.CallSettingsLocalDataSource>(),
      ));
  gh.factory<_i19.RecentJoinedBloc>(
      () => _i19.RecentJoinedBloc(gh<_i9.MeetingLocalDataSource>()));
  return getIt;
}
