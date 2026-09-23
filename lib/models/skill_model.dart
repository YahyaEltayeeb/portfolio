class SkillModel {
  final String name;
  final String category;
  final double proficiency; // 0.0 to 1.0
  final String? iconPath;

  const SkillModel({
    required this.name,
    required this.category,
    required this.proficiency,
    this.iconPath,
  });
}

class SkillCategory {
  final String name;
  final List<SkillModel> skills;

  const SkillCategory({
    required this.name,
    required this.skills,
  });
}
