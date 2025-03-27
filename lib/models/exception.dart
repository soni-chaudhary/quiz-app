class CustomException implements Exception {
  int type;
  String? message;
  CustomException(this.type,this.message);
}