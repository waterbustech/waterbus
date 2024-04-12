// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

// Package imports:
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

// Project imports:
import '../../features/auth/data/datasources/auth_local_datasource.dart' as _i7;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i24;
import '../../features/auth/domain/usecases/check_auth.dart' as _i28;
import '../../features/auth/domain/usecases/login_with_social.dart' as _i27;
import '../../features/auth/domain/usecases/logout.dart' as _i29;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i40;
import '../../features/home/bloc/home/home_bloc.dart' as _i3;
import '../../features/meeting/domain/usecases/create_meeting.dart' as _i30;
import '../../features/meeting/domain/usecases/get_call_settings.dart' as _i32;
import '../../features/meeting/domain/usecases/get_info_meeting.dart' as _i34;
import '../../features/meeting/domain/usecases/get_recent_joined.dart' as _i37;
import '../../features/meeting/domain/usecases/join_meeting.dart' as _i31;
import '../../features/meeting/domain/usecases/save_call_settings.dart' as _i38;
import '../../features/meeting/domain/usecases/update_meeting.dart' as _i33;
import '../../features/profile/domain/usecases/get_presigned_url.dart' as _i21;
import '../../features/profile/domain/usecases/get_profile.dart' as _i22;
import '../../features/profile/domain/usecases/update_profile.dart' as _i20;
import '../../features/profile/domain/usecases/upload_avatar.dart' as _i23;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i26;
import '../../features/systems/bloc/themes/theme_bloc.dart' as _i5;
import '../method_channels/pip_channel.dart' as _i6;
import '../utils/datasources/base_remote_data.dart' as _i11;
import '../utils/dio/dio_configuration.dart' as _i13;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i12;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i25;
import '../../features/meeting/data/datasources/call_settings_datasource.dart'
    as _i9;
import '../../features/meeting/data/datasources/meeting_local_datasource.dart'
    as _i8;
import '../../features/meeting/data/datasources/meeting_remote_datasource.dart'
    as _i14;
import '../../features/meeting/data/repositories/meeting_repository_impl.dart'
    as _i19;
import '../../features/meeting/domain/repositories/meeting_repository.dart'
    as _i18;
import '../../features/meeting/domain/usecases/clean_all_recent_joined.dart'
    as _i36;
import '../../features/meeting/domain/usecases/remove_recent_joined.dart'
    as _i35;
import '../../features/meeting/presentation/bloc/beauty_filters/beauty_filters_bloc.dart'
    as _i4;
import '../../features/meeting/presentation/bloc/meeting/meeting_bloc.dart'
    as _i41;
import '../../features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart'
    as _i39;
import '../../features/profile/data/datasources/user_remote_datasource.dart'
    as _i15;
import '../../features/profile/data/repositories/user_repository_impl.dart'
    as _i17;
import '../../features/profile/domain/repositories/user_repository.dart'
    as _i16;
import '../../features/systems/data/datasources/systems_local_datasource.dart'
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
  gh.factory<_i3.HomeBloc>(() => _i3.HomeBloc());
  gh.factory<_i4.BeautyFiltersBloc>(() => _i4.BeautyFiltersBloc());
  gh.factory<_i5.ThemeBloc>(() => _i5.ThemeBloc());
  gh.singleton<_i6.PipChannel>(() => _i6.PipChannel());
  gh.lazySingleton<_i7.AuthLocalDataSource>(
      () => _i7.AuthLocalDataSourceImpl());
  gh.lazySingleton<_i8.MeetingLocalDataSource>(
      () => _i8.MeetingLocalDataSourceImpl());
  gh.lazySingleton<_i9.CallSettingsLocalDataSource>(
      () => _i9.CallSettingsLocalDataSourceImpl());
  gh.lazySingleton<_i10.SystemLocalDataSource>(
      () => _i10.SystemLocalDataSourceImpl());
  gh.singleton<_i11.BaseRemoteData>(
      () => _i11.BaseRemoteData(gh<_i7.AuthLocalDataSource>()));
  gh.lazySingleton<_i12.AuthRemoteDataSource>(
      () => _i12.AuthRemoteDataSourceImpl(gh<_i11.BaseRemoteData>()));
  gh.singleton<_i13.DioConfiguration>(() => _i13.DioConfiguration(
        gh<_i11.BaseRemoteData>(),
        gh<_i7.AuthLocalDataSource>(),
      ));
  gh.lazySingleton<_i14.MeetingRemoteDataSource>(
      () => _i14.MeetingRemoteDataSourceImpl(gh<_i11.BaseRemoteData>()));
  gh.lazySingleton<_i15.UserRemoteDataSource>(
      () => _i15.UserRemoteDataSourceImpl(gh<_i11.BaseRemoteData>()));
  gh.lazySingleton<_i16.UserRepository>(
      () => _i17.UserRepositoryImpl(gh<_i15.UserRemoteDataSource>()));
  gh.lazySingleton<_i18.MeetingRepository>(() => _i19.MeetingRepositoryImpl(
        gh<_i14.MeetingRemoteDataSource>(),
        gh<_i8.MeetingLocalDataSource>(),
        gh<_i9.CallSettingsLocalDataSource>(),
      ));
  gh.factory<_i20.UpdateProfile>(
      () => _i20.UpdateProfile(gh<_i16.UserRepository>()));
  gh.factory<_i21.GetPresignedUrl>(
      () => _i21.GetPresignedUrl(gh<_i16.UserRepository>()));
  gh.factory<_i22.GetProfile>(() => _i22.GetProfile(gh<_i16.UserRepository>()));
  gh.factory<_i23.UploadAvatar>(
      () => _i23.UploadAvatar(gh<_i16.UserRepository>()));
  gh.lazySingleton<_i24.AuthRepository>(() => _i25.AuthRepositoryImpl(
        gh<_i7.AuthLocalDataSource>(),
        gh<_i12.AuthRemoteDataSource>(),
      ));
  gh.factory<_i26.UserBloc>(() => _i26.UserBloc(
        gh<_i20.UpdateProfile>(),
        gh<_i21.GetPresignedUrl>(),
        gh<_i22.GetProfile>(),
        gh<_i23.UploadAvatar>(),
      ));
  gh.factory<_i27.LoginWithSocial>(
      () => _i27.LoginWithSocial(gh<_i24.AuthRepository>()));
  gh.factory<_i28.CheckAuth>(() => _i28.CheckAuth(gh<_i24.AuthRepository>()));
  gh.factory<_i29.LogOut>(() => _i29.LogOut(gh<_i24.AuthRepository>()));
  gh.factory<_i30.CreateMeeting>(
      () => _i30.CreateMeeting(gh<_i18.MeetingRepository>()));
  gh.factory<_i31.JoinMeeting>(
      () => _i31.JoinMeeting(gh<_i18.MeetingRepository>()));
  gh.factory<_i32.GetCallSettings>(
      () => _i32.GetCallSettings(gh<_i18.MeetingRepository>()));
  gh.factory<_i33.UpdateMeeting>(
      () => _i33.UpdateMeeting(gh<_i18.MeetingRepository>()));
  gh.factory<_i34.GetInfoMeeting>(
      () => _i34.GetInfoMeeting(gh<_i18.MeetingRepository>()));
  gh.factory<_i35.RemoveRecentJoined>(
      () => _i35.RemoveRecentJoined(gh<_i18.MeetingRepository>()));
  gh.factory<_i36.CleanAllRecentJoined>(
      () => _i36.CleanAllRecentJoined(gh<_i18.MeetingRepository>()));
  gh.factory<_i37.GetRecentJoined>(
      () => _i37.GetRecentJoined(gh<_i18.MeetingRepository>()));
  gh.factory<_i38.SaveCallSettings>(
      () => _i38.SaveCallSettings(gh<_i18.MeetingRepository>()));
  gh.factory<_i39.RecentJoinedBloc>(() => _i39.RecentJoinedBloc(
        gh<_i37.GetRecentJoined>(),
        gh<_i35.RemoveRecentJoined>(),
        gh<_i36.CleanAllRecentJoined>(),
      ));
  gh.factory<_i40.AuthBloc>(() => _i40.AuthBloc(
        gh<_i28.CheckAuth>(),
        gh<_i27.LoginWithSocial>(),
        gh<_i29.LogOut>(),
      ));
  gh.factory<_i41.MeetingBloc>(() => _i41.MeetingBloc(
        gh<_i30.CreateMeeting>(),
        gh<_i31.JoinMeeting>(),
        gh<_i33.UpdateMeeting>(),
        gh<_i34.GetInfoMeeting>(),
        gh<_i32.GetCallSettings>(),
        gh<_i38.SaveCallSettings>(),
        gh<_i6.PipChannel>(),
      ));
  return getIt;
}
