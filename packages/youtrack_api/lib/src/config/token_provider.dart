




abstract interface class TokenProvider {
  Future<String?> getAuthToken();
  Future<void> onAuthenticationError();
}