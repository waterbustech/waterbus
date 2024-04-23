class ApiEndpoints {
  static const String baseUrl = 'https://service.waterbus.tech/busapi/v1/';
  static const String wsUrl = 'https://sfu.waterbus.tech';
  // static const String baseUrl = 'http://192.168.1.113:5980/busapi/v1/';
  // static const String wsUrl = 'http://192.168.1.113:5985';

  // Auth
  static const String auth = 'auth';
  static const String presignedUrlS3 = 'auth/presigned-url';

  // Users
  static const String users = 'users';

  // Meetings
  static const String meetings = 'meetings';
  static const String joinWithPassword = 'meetings/join/password';
  static const String joinWithoutPassword = 'meetings/join';

  // Chats
  static const String chats = 'chats';
}
