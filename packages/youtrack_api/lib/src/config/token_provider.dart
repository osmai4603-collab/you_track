




abstract interface class TokenProvider {
  Future<String?> getAuthToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
  Future<void> onAuthenticationError();
}