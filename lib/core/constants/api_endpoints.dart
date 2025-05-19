class ApiEndpoints {
  static const String baseUrl =
      'https://services.waterbus.tech/busapi/v3/'; // HTTP3 for IO Platforms
  static const String baseUrlForWeb =
      'https://service-v3.waterbus.tech/busapi/v3/'; // HTTP2 for Web
  static const String wsUrl = 'https://service-v3.waterbus.tech';

  // Auth
  static const String auth = 'auth';

  // Users
  static const String users = 'users';
  static const String username = 'users/username';

  // Meetings
  static const String meetings = 'meetings';
  static const String joinWithPassword = 'meetings/join/password';
  static const String joinWithoutPassword = 'meetings/join';

  // Chats
  static const String chats = 'chats';
}
