class Project {
  final String title;
  final String description;
  final String detailedDescription;
  final List<String> tags;
  final String? link;
  final String? imageUrl;
  final String? videoUrl;
  final String? demoUrl;
  final List<String> features;
  final List<String> technologies;
  final String? githubUrl;

  Project({
    required this.title,
    required this.description,
    required this.detailedDescription,
    required this.tags,
    this.link,
    this.imageUrl,
    this.videoUrl,
    this.demoUrl,
    this.features = const [],
    this.technologies = const [],
    this.githubUrl,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'],
      description: json['description'],
      detailedDescription: json['detailedDescription'] ?? json['description'],
      tags: List<String>.from(json['tags']),
      link: json['link'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      demoUrl: json['demoUrl'],
      features: List<String>.from(json['features'] ?? []),
      technologies: List<String>.from(json['technologies'] ?? []),
      githubUrl: json['githubUrl'],
    );
  }
}
