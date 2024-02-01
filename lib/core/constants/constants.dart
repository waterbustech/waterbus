// Project imports:
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

const User userDefault = User(
  id: 0,
  fullName: 'Waterbus',
  userName: 'waterbus.tech',
  avatar: 'https://avatars.githubusercontent.com/u/60530946?v=4',
);

const gridViewMinUsers = 4;

final Map<String, BeautyFilter> filters = {
  'Normal': BeautyFilter(),
  'Classic': BeautyFilter(contrast: 1.2, brightness: 0.8, saturation: 1.2),
  'Vintage': BeautyFilter(contrast: 0.8, brightness: 1.2, saturation: 0.8),
  'Black and White': BeautyFilter(saturation: 0.0),
  'Sepia': BeautyFilter(saturation: 0.5, brightness: 1.2),
  'HDR': BeautyFilter(contrast: 1.5, brightness: 1.3),
  'Soft Glow': BeautyFilter(blurRadius: 2.0, brightness: 1.2),
  'Cool Blue': BeautyFilter(saturation: 1.2, brightness: 0.8),
  'Pop Art': BeautyFilter(saturation: 1.5, contrast: 1.2),
  'Cinema': BeautyFilter(contrast: 1.2, brightness: 0.8),
  'Dramatic': BeautyFilter(contrast: 1.8, saturation: 1.2),
  'Pastel': BeautyFilter(contrast: 0.8, brightness: 1.2),
  'Faded': BeautyFilter(contrast: 0.8, brightness: 0.8),
};
