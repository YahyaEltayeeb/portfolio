class ProjectModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> features;
  final List<String> techStack;
  final List<String> screenshots;
  final String? githubUrl;
  final String? liveDemoUrl;
  final String? architectureOverview;
  final String thumbnailUrl;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
    required this.techStack,
    this.screenshots = const [],
    this.githubUrl,
    this.liveDemoUrl,
    this.architectureOverview,
    this.thumbnailUrl = '',
  });
}
