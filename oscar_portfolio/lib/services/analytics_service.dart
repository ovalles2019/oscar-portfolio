import 'dart:html' as html;
import 'dart:js' as js;

class AnalyticsService {
  static const String _measurementId = 'G-XXXXXXXXXX'; // Replace with your GA4 Measurement ID
  
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Check if gtag is already loaded
      if (js.context.hasProperty('gtag')) {
        _isInitialized = true;
        print('Analytics already initialized');
        return;
      }
      
      // Load Google Analytics script
      final script = html.ScriptElement()
        ..src = 'https://www.googletagmanager.com/gtag/js?id=$_measurementId'
        ..async = true;
      
      html.document.head!.append(script);
      
      // Wait for script to load and initialize
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Configure gtag
      js.context.callMethod('gtag', ['config', _measurementId, {
        'page_title': 'Oscar Valles Portfolio',
        'page_location': html.window.location.href,
      }]);
      
      _isInitialized = true;
      print('Analytics initialized successfully');
    } catch (e) {
      print('Failed to initialize analytics: $e');
    }
  }

  Future<void> trackPageView(String pageName) async {
    if (!_isInitialized) return;
    
    try {
      js.context.callMethod('gtag', ['event', 'page_view', {
        'page_title': pageName,
        'page_location': html.window.location.href,
        'page_path': '/$pageName',
      }]);
      print('Tracked page view: $pageName');
    } catch (e) {
      print('Failed to track page view: $e');
    }
  }

  Future<void> trackResumeDownload() async {
    if (!_isInitialized) return;
    
    try {
      js.context.callMethod('gtag', ['event', 'resume_download', {
        'event_category': 'engagement',
        'event_label': 'resume_download',
        'value': 1,
      }]);
      print('Tracked resume download');
    } catch (e) {
      print('Failed to track resume download: $e');
    }
  }

  Future<void> trackProjectView(String projectTitle) async {
    if (!_isInitialized) return;
    
    try {
      js.context.callMethod('gtag', ['event', 'project_view', {
        'event_category': 'engagement',
        'event_label': projectTitle,
        'value': 1,
      }]);
      print('Tracked project view: $projectTitle');
    } catch (e) {
      print('Failed to track project view: $e');
    }
  }

  Future<void> trackContactClick() async {
    if (!_isInitialized) return;
    
    try {
      js.context.callMethod('gtag', ['event', 'contact_click', {
        'event_category': 'engagement',
        'event_label': 'contact_section',
        'value': 1,
      }]);
      print('Tracked contact click');
    } catch (e) {
      print('Failed to track contact click: $e');
    }
  }

  Future<void> trackGitHubClick() async {
    if (!_isInitialized) return;
    
    try {
      js.context.callMethod('gtag', ['event', 'github_click', {
        'event_category': 'engagement',
        'event_label': 'github_profile',
        'value': 1,
      }]);
      print('Tracked GitHub click');
    } catch (e) {
      print('Failed to track GitHub click: $e');
    }
  }
} 