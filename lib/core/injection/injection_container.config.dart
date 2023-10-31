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
import '../../features/auth/data/datasources/auth_local_datasource.dart' as _i3;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i19;
import '../../features/auth/domain/usecases/check_auth.dart' as _i21;
import '../../features/auth/domain/usecases/login_with_social.dart' as _i33;
import '../../features/auth/domain/usecases/logout.dart' as _i32;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i39;
import '../../features/home/bloc/home/home_bloc.dart' as _i7;
import '../../features/meeting/domain/usecases/create_meeting.dart' as _i23;
import '../../features/meeting/domain/usecases/get_call_settings.dart' as _i24;
import '../../features/meeting/domain/usecases/get_info_meeting.dart' as _i25;
import '../../features/meeting/domain/usecases/get_participant.dart' as _i26;
import '../../features/meeting/domain/usecases/get_recent_joined.dart' as _i29;
import '../../features/meeting/domain/usecases/join_meeting.dart' as _i30;
import '../../features/meeting/domain/usecases/leave_meeting.dart' as _i31;
import '../../features/meeting/domain/usecases/save_call_settings.dart' as _i12;
import '../../features/meeting/domain/usecases/update_meeting.dart' as _i14;
import '../../features/profile/domain/usecases/get_presigned_url.dart' as _i27;
import '../../features/profile/domain/usecases/get_profile.dart' as _i28;
import '../../features/profile/domain/usecases/update_profile.dart' as _i36;
import '../../features/profile/domain/usecases/upload_avatar.dart' as _i37;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i38;
import '../../features/schedule/blocs/schedule/schedule_bloc.dart' as _i13;
import '../utils/datasources/base_remote_data.dart' as _i4;
import '../utils/dio/dio_configuration.dart' as _i6;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i18;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i20;
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
    as _i22;
import '../../features/meeting/presentation/bloc/meeting/meeting_bloc.dart'
    as _i34;
import '../../features/meeting/presentation/bloc/meeting_list/bloc/meeting_list_bloc.dart'
    as _i35;
import '../../features/profile/data/datasources/user_remote_datasource.dart'
    as _i15;
import '../../features/profile/data/repositories/user_repository_impl.dart'
    as _i17;
import '../../features/profile/domain/repositories/user_repository.dart'
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
  gh.factory<_i12.SaveCallSettings>(
      () => _i12.SaveCallSettings(gh<_i10.MeetingRepository>()));
  gh.factory<_i13.ScheduleBloc>(() => _i13.ScheduleBloc());
  gh.factory<_i14.UpdateMeeting>(
      () => _i14.UpdateMeeting(gh<_i10.MeetingRepository>()));
  gh.lazySingleton<_i15.UserRemoteDataSource>(
      () => _i15.UserRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i16.UserRepository>(
      () => _i17.UserRepositoryImpl(gh<_i15.UserRemoteDataSource>()));
  gh.lazySingleton<_i18.AuthRemoteDataSource>(
      () => _i18.AuthRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i19.AuthRepository>(() => _i20.AuthRepositoryImpl(
        gh<_i3.AuthLocalDataSource>(),
        gh<_i18.AuthRemoteDataSource>(),
      ));
  gh.factory<_i21.CheckAuth>(() => _i21.CheckAuth(gh<_i19.AuthRepository>()));
  gh.factory<_i22.CleanAllRecentJoined>(
      () => _i22.CleanAllRecentJoined(gh<_i10.MeetingRepository>()));
  gh.factory<_i23.CreateMeeting>(
      () => _i23.CreateMeeting(gh<_i10.MeetingRepository>()));
  gh.factory<_i24.GetCallSettings>(
      () => _i24.GetCallSettings(gh<_i10.MeetingRepository>()));
  gh.factory<_i25.GetInfoMeeting>(
      () => _i25.GetInfoMeeting(gh<_i10.MeetingRepository>()));
  gh.factory<_i26.GetParticipant>(
      () => _i26.GetParticipant(gh<_i10.MeetingRepository>()));
  gh.factory<_i27.GetPresignedUrl>(
      () => _i27.GetPresignedUrl(gh<_i16.UserRepository>()));
  gh.factory<_i28.GetProfile>(() => _i28.GetProfile(gh<_i16.UserRepository>()));
  gh.factory<_i29.GetRecentJoined>(
      () => _i29.GetRecentJoined(gh<_i10.MeetingRepository>()));
  gh.factory<_i30.JoinMeeting>(
      () => _i30.JoinMeeting(gh<_i10.MeetingRepository>()));
  gh.factory<_i31.LeaveMeeting>(
      () => _i31.LeaveMeeting(gh<_i10.MeetingRepository>()));
  gh.factory<_i32.LogOut>(() => _i32.LogOut(gh<_i19.AuthRepository>()));
  gh.factory<_i33.LoginWithSocial>(
      () => _i33.LoginWithSocial(gh<_i19.AuthRepository>()));
  gh.factory<_i34.MeetingBloc>(() => _i34.MeetingBloc(
        gh<_i23.CreateMeeting>(),
        gh<_i30.JoinMeeting>(),
        gh<_i14.UpdateMeeting>(),
        gh<_i25.GetInfoMeeting>(),
        gh<_i31.LeaveMeeting>(),
        gh<_i26.GetParticipant>(),
        gh<_i24.GetCallSettings>(),
        gh<_i12.SaveCallSettings>(),
      ));
  gh.factory<_i35.MeetingListBloc>(() => _i35.MeetingListBloc(
        gh<_i29.GetRecentJoined>(),
        gh<_i22.CleanAllRecentJoined>(),
      ));
  gh.factory<_i36.UpdateProfile>(
      () => _i36.UpdateProfile(gh<_i16.UserRepository>()));
  gh.factory<_i37.UploadAvatar>(
      () => _i37.UploadAvatar(gh<_i16.UserRepository>()));
  gh.factory<_i38.UserBloc>(() => _i38.UserBloc(
        gh<_i36.UpdateProfile>(),
        gh<_i27.GetPresignedUrl>(),
        gh<_i28.GetProfile>(),
        gh<_i37.UploadAvatar>(),
      ));
  gh.factory<_i39.AuthBloc>(() => _i39.AuthBloc(
        gh<_i21.CheckAuth>(),
        gh<_i33.LoginWithSocial>(),
        gh<_i32.LogOut>(),
      ));
  return getIt;
}
