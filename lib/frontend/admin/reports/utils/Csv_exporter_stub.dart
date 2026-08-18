/// Non-web platforms (Android/iOS/desktop) don't support triggering a
/// browser download. Returns false so the caller can show a message.
/// (To support real file export on those platforms later, use
/// package:path_provider + package:share_plus instead.)
bool downloadCsv(String csvContent, String filename) {
  return false;
}