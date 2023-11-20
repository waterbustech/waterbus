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
import 'package:simple_pip_mode/simple_pip.dart' as _i36;

// Project imports:
import '../../features/auth/data/datasources/auth_local_datasource.dart' as _i3;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i20;
import '../../features/auth/domain/usecases/check_auth.dart' as _i22;
import '../../features/auth/domain/usecases/login_with_social.dart' as _i34;
import '../../features/auth/domain/usecases/logout.dart' as _i33;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i41;
import '../../features/home/bloc/home/home_bloc.dart' as _i7;
import '../../features/meeting/domain/usecases/create_meeting.dart' as _i24;
import '../../features/meeting/domain/usecases/get_call_settings.dart' as _i25;
import '../../features/meeting/domain/usecases/get_info_meeting.dart' as _i26;
import '../../features/meeting/domain/usecases/get_participant.dart' as _i27;
import '../../features/meeting/domain/usecases/get_recent_joined.dart' as _i30;
import '../../features/meeting/domain/usecases/join_meeting.dart' as _i31;
import '../../features/meeting/domain/usecases/leave_meeting.dart' as _i32;
import '../../features/meeting/domain/usecases/save_call_settings.dart' as _i13;
import '../../features/meeting/domain/usecases/update_meeting.dart' as _i15;
import '../../features/profile/domain/usecases/get_presigned_url.dart' as _i28;
import '../../features/profile/domain/usecases/get_profile.dart' as _i29;
import '../../features/profile/domain/usecases/update_profile.dart' as _i38;
import '../../features/profile/domain/usecases/upload_avatar.dart' as _i39;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i40;
import '../../features/schedule/blocs/schedule/schedule_bloc.dart' as _i14;
import '../method_channels/pip_channel.dart' as _i12;
import '../utils/datasources/base_remote_data.dart' as _i4;
import '../utils/dio/dio_configuration.dart' as _i6;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i19;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i21;
import '../../features/meeting/data/datasources/call_settings_datasource.dart'
    as _i5;
import '../../features/meeting/data/datasources/meeting_local_datasource.dart'
    as _i8;
import '../../features/meeting/data/datasources/meeting_remote_datasource.dart'
    as _i9;
import '../../features/meeting/data/repositories/meeting_repository_impl.dart'
    as _i11;
import '../../features/meeting/domain/repositories/meeting_repository.dart'
    as _i10;
import '../../features/meeting/domain/usecases/clean_all_recent_joined.dart'
    as _i23;
import '../../features/meeting/presentation/bloc/meeting/meeting_bloc.dart'
    as _i35;
import '../../features/meeting/presentation/bloc/meeting_list/bloc/meeting_list_bloc.dart'
    as _i37;
import '../../features/profile/data/datasources/user_remote_datasource.dart'
    as _i16;
import '../../features/profile/data/repositories/user_repository_impl.dart'
    as _i18;
import '../../features/profile/domain/repositories/user_repository.dart'
    as _i17;

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
  gh.lazySingleton<_i5.CallSettingsLocalDataSource>(
      () => _i5.CallSettingsLocalDataSourceImpl());
  gh.singleton<_i6.DioConfiguration>(_i6.DioConfiguration(
    gh<_i4.BaseRemoteData>(),
    gh<_i3.AuthLocalDataSource>(),
  ));
  gh.factory<_i7.HomeBloc>(() => _i7.HomeBloc());
  gh.lazySingleton<_i8.MeetingLocalDataSource>(
      () => _i8.MeetingLocalDataSourceImpl());
  gh.lazySingleton<_i9.MeetingRemoteDataSource>(
      () => _i9.MeetingRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i10.MeetingRepository>(() => _i11.MeetingRepositoryImpl(
        gh<_i9.MeetingRemoteDataSource>(),
        gh<_i8.MeetingLocalDataSource>(),
        gh<_i5.CallSettingsLocalDataSource>(),
      ));
  gh.singleton<_i12.PipChannel>(_i12.PipChannel());
  gh.factory<_i13.SaveCallSettings>(
      () => _i13.SaveCallSettings(gh<_i10.MeetingRepository>()));
  gh.factory<_i14.ScheduleBloc>(() => _i14.ScheduleBloc());
  gh.factory<_i15.UpdateMeeting>(
      () => _i15.UpdateMeeting(gh<_i10.MeetingRepository>()));
  gh.lazySingleton<_i16.UserRemoteDataSource>(
      () => _i16.UserRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i17.UserRepository>(
      () => _i18.UserRepositoryImpl(gh<_i16.UserRemoteDataSource>()));
  gh.lazySingleton<_i19.AuthRemoteDataSource>(
      () => _i19.AuthRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i20.AuthRepository>(() => _i21.AuthRepositoryImpl(
        gh<_i3.AuthLocalDataSource>(),
        gh<_i19.AuthRemoteDataSource>(),
      ));
  gh.factory<_i22.CheckAuth>(() => _i22.CheckAuth(gh<_i20.AuthRepository>()));
  gh.factory<_i23.CleanAllRecentJoined>(
      () => _i23.CleanAllRecentJoined(gh<_i10.MeetingRepository>()));
  gh.factory<_i24.CreateMeeting>(
      () => _i24.CreateMeeting(gh<_i10.MeetingRepository>()));
  gh.factory<_i25.GetCallSettings>(
      () => _i25.GetCallSettings(gh<_i10.MeetingRepository>()));
  gh.factory<_i26.GetInfoMeeting>(
      () => _i26.GetInfoMeeting(gh<_i10.MeetingRepository>()));
  gh.factory<_i27.GetParticipant>(
      () => _i27.GetParticipant(gh<_i10.MeetingRepository>()));
  gh.factory<_i28.GetPresignedUrl>(
      () => _i28.GetPresignedUrl(gh<_i17.UserRepository>()));
  gh.factory<_i29.GetProfile>(() => _i29.GetProfile(gh<_i17.UserRepository>()));
  gh.factory<_i30.GetRecentJoined>(
      () => _i30.GetRecentJoined(gh<_i10.MeetingRepository>()));
  gh.factory<_i31.JoinMeeting>(
      () => _i31.JoinMeeting(gh<_i10.MeetingRepository>()));
  gh.factory<_i32.LeaveMeeting>(
      () => _i32.LeaveMeeting(gh<_i10.MeetingRepository>()));
  gh.factory<_i33.LogOut>(() => _i33.LogOut(gh<_i20.AuthRepository>()));
  gh.factory<_i34.LoginWithSocial>(
      () => _i34.LoginWithSocial(gh<_i20.AuthRepository>()));
  gh.factory<_i35.MeetingBloc>(() => _i35.MeetingBloc(
        gh<_i24.CreateMeeting>(),
        gh<_i31.JoinMeeting>(),
        gh<_i15.UpdateMeeting>(),
        gh<_i26.GetInfoMeeting>(),
        gh<_i32.LeaveMeeting>(),
        gh<_i27.GetParticipant>(),
        gh<_i25.GetCallSettings>(),
        gh<_i13.SaveCallSettings>(),
        gh<_i12.PipChannel>(),
        gh<_i36.SimplePip>(),
      ));
  gh.factory<_i37.MeetingListBloc>(() => _i37.MeetingListBloc(
        gh<_i30.GetRecentJoined>(),
        gh<_i23.CleanAllRecentJoined>(),
      ));
  gh.factory<_i38.UpdateProfile>(
      () => _i38.UpdateProfile(gh<_i17.UserRepository>()));
  gh.factory<_i39.UploadAvatar>(
      () => _i39.UploadAvatar(gh<_i17.UserRepository>()));
  gh.factory<_i40.UserBloc>(() => _i40.UserBloc(
        gh<_i38.UpdateProfile>(),
        gh<_i28.GetPresignedUrl>(),
        gh<_i29.GetProfile>(),
        gh<_i39.UploadAvatar>(),
      ));
  gh.factory<_i41.AuthBloc>(() => _i41.AuthBloc(
        gh<_i22.CheckAuth>(),
        gh<_i34.LoginWithSocial>(),
        gh<_i33.LogOut>(),
      ));
  return getIt;
}
