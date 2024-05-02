class ErrorHandler {
  static void catchError(Object exception, {String methodName = ''}) {
    print('$methodName exception - $exception');
  }
}
