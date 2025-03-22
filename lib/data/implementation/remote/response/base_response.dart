class BaseResponse<T> {
  final bool error;
  final String message;
  final T? data;

  BaseResponse({
    required this.error,
    required this.message,
    this.data,
  });

  factory BaseResponse.fromJson(
      Map<String, dynamic> json, 
      T Function(Map<String, dynamic>)? fromJsonT,
      String? resultName,
    ) {
    return BaseResponse(
      error: json['error'],
      message: json['message'],
      data: json.containsKey(resultName) && fromJsonT != null
          ? fromJsonT(json[resultName])
          : null,
    );
  }
}