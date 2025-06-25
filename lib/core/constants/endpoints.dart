class Endpoints {
  // static const String baseUrl = 'https://services.waterbus.tech';
  static const String baseUrl = 'http://localhost:5998';
  static const String apiPath = '/busapi/v3/';

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
