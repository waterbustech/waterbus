class ApiEndpoints {
  static const String baseUrl = 'https://service-v2.waterbus.tech/busapi/v1/';
  static const String wsUrl = 'https://sfu-v2.waterbus.tech';
  // static const String baseUrl = 'http://192.168.1.12:5980/busapi/v1/';
  // static const String wsUrl = 'http://192.168.1.12:5985';

  // Auth
  static const String auth = 'auth';
  static const String presignedUrlS3 = 'auth/presigned-url';

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
