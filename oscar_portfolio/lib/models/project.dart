class Project {
  final String title;
  final String description;
  final List<String> tags;
  final String? link;

  Project({
    required this.title,
    required this.description,
    required this.tags,
    this.link,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'],
      description: json['description'],
      tags: List<String>.from(json['tags']),
      link: json['link'],
    );
  }
}
