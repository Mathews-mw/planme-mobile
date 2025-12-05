enum ProviderType {
  credentials,
  google;

  String get value {
    switch (this) {
      case ProviderType.credentials:
        return 'credentials';
      case ProviderType.google:
        return 'google';
    }
  }

  String get label {
    switch (this) {
      case ProviderType.credentials:
        return 'Credentials';
      case ProviderType.google:
        return 'Google';
    }
  }
}
