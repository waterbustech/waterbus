// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i18;
import '../../features/chats/presentation/bloc/chat_bloc.dart' as _i6;
import '../../features/chats/presentation/bloc/invited_chat_bloc.dart' as _i7;
import '../../features/conversation/bloc/message_bloc.dart' as _i8;
import '../../features/conversation/socket/socket_chat_handle.dart' as _i14;
import '../../features/home/bloc/home/home_bloc.dart' as _i3;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i5;
import '../../features/settings/lang/datasource/lang_datasource.dart' as _i13;
import '../../features/settings/themes/bloc/themes_bloc.dart' as _i17;
import '../../features/settings/themes/data/themes_datasource.dart' as _i12;
import '../method_channels/pip_channel.dart' as _i9;

import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart'
    as _i15;

import '../../features/chats/data/datasources/user_local_datasource.dart'
    as _i16;
import '../../features/meeting/data/datasources/call_settings_datasource.dart'
    as _i11;
import '../../features/meeting/data/datasources/meeting_local_datasource.dart'
    as _i10;
import '../../features/meeting/presentation/bloc/beauty_filters/beauty_filters_bloc.dart'
    as _i4;
import '../../features/meeting/presentation/bloc/meeting/meeting_bloc.dart'
    as _i19;
import '../../features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart'
    as _i20;

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
  gh.factory<_i7.InvitedChatBloc>(() => _i7.InvitedChatBloc());
  gh.factory<_i8.MessageBloc>(() => _i8.MessageBloc());
  gh.singleton<_i9.PipChannel>(() => _i9.PipChannel());
  gh.lazySingleton<_i10.MeetingLocalDataSource>(
      () => _i10.MeetingLocalDataSourceImpl());
  gh.lazySingleton<_i11.CallSettingsLocalDataSource>(
      () => _i11.CallSettingsLocalDataSourceImpl());
  gh.lazySingleton<_i12.ThemesDatasource>(() => _i12.ThemesDatasourceImpl());
  gh.lazySingleton<_i13.LanguagesDatasource>(
      () => _i13.LanguagesDatasourceImpl());
  gh.factory<_i14.SocketChatHandle>(
      () => _i14.SocketChatHandle(gh<_i15.SocketHandler>()));
  gh.lazySingleton<_i16.UserLocalDataSource>(
      () => _i16.UserLocalDataSourceImpl());
  gh.factory<_i17.ThemesBloc>(
      () => _i17.ThemesBloc(gh<_i12.ThemesDatasource>()));
  gh.factory<_i18.AuthBloc>(
      () => _i18.AuthBloc(gh<_i16.UserLocalDataSource>()));
  gh.factory<_i19.MeetingBloc>(() => _i19.MeetingBloc(
        gh<_i9.PipChannel>(),
        gh<_i10.MeetingLocalDataSource>(),
        gh<_i11.CallSettingsLocalDataSource>(),
      ));
  gh.factory<_i20.RecentJoinedBloc>(
      () => _i20.RecentJoinedBloc(gh<_i10.MeetingLocalDataSource>()));
  return getIt;
}
