part of 'notification_setting_bloc.dart';

sealed class NotificationSettingState extends Equatable {
  final NotificationSettings notificationSettings;

  const NotificationSettingState(this.notificationSettings);

  @override
  List<Object> get props => [];
}

final class NotificationSettingInitial extends NotificationSettingState {
  const NotificationSettingInitial(super.notificationSettings);
}

final class NotificationSettingUpdating extends NotificationSettingState {
  const NotificationSettingUpdating(super.notificationSettings);
}

final class NotificationSettingSuccessed extends NotificationSettingState {
  const NotificationSettingSuccessed(super.notificationSettings);
}
