class AuthResponse {
  final bool isSuccess;
  final AuthError? error;

  AuthResponse(this.isSuccess, {this.error});

  factory AuthResponse.success() {
    return AuthResponse(true);
  }

  factory AuthResponse.error(String code, String message) {
    return AuthResponse(false, error: AuthError(code, message));
  }
}

class AuthError {
  final String code;
  final String message;

  AuthError(this.code, this.message);
}