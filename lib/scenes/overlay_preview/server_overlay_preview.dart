abstract interface class ServerOverlayPreview {
  Future<bool> checkPermission();
  Future<void> requestPermission();
}

class DefaultServerOverlayPreview implements ServerOverlayPreview {
  const DefaultServerOverlayPreview();

  @override
  Future<bool> checkPermission() async => true;

  @override
  Future<void> requestPermission() async {}
}
