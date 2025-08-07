part of 'notification_setting_bloc.dart';

sealed class NotificationSettingEvent extends Equatable {
  const NotificationSettingEvent();

  @override
  List<Object> get props => [];
}

final class NotificationSettingGet extends NotificationSettingEvent {}

final class NotificationSettingUpdate extends NotificationSettingEvent {
  final NotificationSettings settings;

  const NotificationSettingUpdate({required this.settings});
}
