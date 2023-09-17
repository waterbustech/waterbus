class ApiEndpoints {
  static const String baseUrl = 'http://149.28.156.10:5980/busapi/v1/';
  static const String wsUrl = '';

  // Auth
  static const String signIn = 'auth/login';
  static const String refreshToken = 'auth/refresh';
  static const String signOut = 'auth/logout';
  static const String presignedUrlS3 = 'auth/presigned-url';

  // Users
  static const String users = 'users';

  // Meetings
  static const String meetings = 'meetings';
}
