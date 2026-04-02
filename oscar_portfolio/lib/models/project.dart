class Project {
  final String title;
  final String description;
  final String detailedDescription;
  final List<String> tags;
  final String? link;
  final String? imageUrl;
  final String? videoUrl;
  final String? demoUrl;
  final String? liveUrl;
  final List<String> features;
  final List<String> technologies;
  final String? githubUrl;
  final String category;

  Project({
    required this.title,
    required this.description,
    required this.detailedDescription,
    required this.tags,
    this.link,
    this.imageUrl,
    this.videoUrl,
    this.demoUrl,
    this.liveUrl,
    this.features = const [],
    this.technologies = const [],
    this.githubUrl,
    this.category = 'Featured Work',
  });

  String? get primaryLink => liveUrl ?? demoUrl ?? link ?? githubUrl;

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] as String,
      description: json['description'] as String,
      detailedDescription:
          (json['detailedDescription'] ?? json['description']) as String,
      tags: List<String>.from(json['tags'] ?? const []),
      link: json['link'] as String?,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      demoUrl: json['demoUrl'] as String?,
      liveUrl: json['liveUrl'] as String?,
      features: List<String>.from(json['features'] ?? const []),
      technologies: List<String>.from(json['technologies'] ?? const []),
      githubUrl: json['githubUrl'] as String?,
      category: (json['category'] ?? 'Featured Work') as String,
    );
  }
}
