class StatusCode {
  static const int continueCode = 100;
  static const int switchingProtocols = 101;
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int notiAuthoritativeInfomation = 203;
  static const int noContent = 204;
  static const int resetContent = 205;
  static const int partialContent = 206;
  static const int multipleChoices = 300;
  static const int movedPermanently = 301;
  static const int found = 302;
  static const int seeOther = 303;
  static const int notModified = 304;
  static const int useProxy = 305;
  static const int temporaryRedirect = 307;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int paymentRequired = 402;
  static const int forbiden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int notAcceptable = 406;
  static const int proxyAuthenticationRequired = 407;
  static const int requestTimeout = 408;
  static const int conflict = 409;
  static const int gone = 410;
  static const int lengthRequired = 411;
  static const int preconditionFailed = 412;
  static const int requestEntityTooLarge = 413;
  static const int requestUriTooLong = 414;
  static const int unsupportedMediaType = 415;
  static const int requestedRangeNotSatisfiable = 416;
  static const int expectationFailed = 417;
  static const int internalServerError = 500;
  static const int notImplemented = 501;
  static const int badGateway = 502;

  static List<int> get validateStatus =>
      [unauthorized, notFound, internalServerError, badGateway];
}
