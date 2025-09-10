import 'dart:html' as html;

class DownloadCounterService {
  static const String _storageKey = 'resume_download_count';
  static int _downloadCount = 0;
  static bool _initialized = false;

  static void _initialize() {
    if (_initialized) return;
    
    try {
      final stored = html.window.localStorage[_storageKey];
      _downloadCount = stored != null ? int.tryParse(stored) ?? 0 : 0;
    } catch (e) {
      _downloadCount = 0;
    }
    
    _initialized = true;
  }

  static int get downloadCount {
    _initialize();
    return _downloadCount;
  }

  static void incrementDownloadCount() {
    _initialize();
    _downloadCount++;
    try {
      html.window.localStorage[_storageKey] = _downloadCount.toString();
    } catch (e) {
      // If localStorage is not available, just keep the count in memory
    }
  }

  static String get downloadCountText {
    final count = downloadCount;
    if (count == 0) return 'Download Resume';
    if (count == 1) return 'Download Resume (1 download)';
    return 'Download Resume ($count downloads)';
  }
}
