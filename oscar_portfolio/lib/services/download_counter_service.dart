import 'dart:html' as html;
import 'dart:convert';

class DownloadCounterService {
  static const String _storageKey = 'resume_download_count';
  static const String _lastDownloadKey = 'last_download_date';
  
  static final DownloadCounterService _instance = DownloadCounterService._internal();
  factory DownloadCounterService() => _instance;
  DownloadCounterService._internal();

  int get downloadCount {
    try {
      final stored = html.window.localStorage[_storageKey];
      return stored != null ? int.tryParse(stored) ?? 0 : 0;
    } catch (e) {
      print('Error reading download count: $e');
      return 0;
    }
  }

  String get lastDownloadDate {
    try {
      final stored = html.window.localStorage[_lastDownloadKey];
      if (stored != null) {
        final date = DateTime.tryParse(stored);
        if (date != null) {
          return _formatDate(date);
        }
      }
      return 'Never';
    } catch (e) {
      print('Error reading last download date: $e');
      return 'Never';
    }
  }

  void incrementDownloadCount() {
    try {
      final newCount = downloadCount + 1;
      html.window.localStorage[_storageKey] = newCount.toString();
      html.window.localStorage[_lastDownloadKey] = DateTime.now().toIso8601String();
      print('Download count incremented to: $newCount');
    } catch (e) {
      print('Error incrementing download count: $e');
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String get downloadCountText {
    final count = downloadCount;
    if (count == 0) return 'No downloads yet';
    if (count == 1) return '1 download';
    return '$count downloads';
  }

  bool get hasDownloads => downloadCount > 0;
} 