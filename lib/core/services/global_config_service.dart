class GlobalConfigService {
  GlobalConfigService();

  String? _customBaseURL;
  String? get customBaseURL => _customBaseURL;

  void setCustomBaseURL(String? url) {
    _customBaseURL = url;
  }
}
