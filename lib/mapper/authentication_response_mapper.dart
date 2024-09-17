

import '../data/response/login_response.dart';

extension AuthenticationResponseMapper on LoginResponse? {
  LoginResponse toDomain() {
    return LoginResponse(
      accessToken: this?.accessToken ?? '',
      refreshToken: this?.refreshToken ?? '',
    );
  }
}