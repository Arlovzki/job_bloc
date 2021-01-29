class ApiResponse {
  final int error;
  final String message;
  final dynamic data;

  ApiResponse(this.error, this.message, this.data);

  ApiResponse.fromJson(Map<String, dynamic> json)
      : error = json["error"],
        message = json["message"],
        data = json["data"];
}
