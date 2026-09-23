import '../models/skill_model.dart';

class SkillsRepository {
  const SkillsRepository();

  List<SkillModel> getSkills() {
    return const [
      // Development
      SkillModel(id: 'dart', name: 'Dart', category: 'Development'),
      SkillModel(id: 'flutter', name: 'Flutter', category: 'Development'),

      // Architecture
      SkillModel(
        id: 'clean-arch',
        name: 'Clean Architecture',
        category: 'Architecture',
      ),
      SkillModel(id: 'mvvm', name: 'MVVM', category: 'Architecture'),
      SkillModel(id: 'mvi', name: 'MVI', category: 'Architecture'),

      // State Management
      SkillModel(id: 'bloc', name: 'BLoC', category: 'State Management'),
      SkillModel(id: 'cubit', name: 'Cubit', category: 'State Management'),
      SkillModel(
        id: 'provider',
        name: 'Provider',
        category: 'State Management',
      ),

      // Networking
      SkillModel(id: 'rest-apis', name: 'REST APIs', category: 'Networking'),
      SkillModel(id: 'dio', name: 'Dio', category: 'Networking'),
      SkillModel(id: 'retrofit', name: 'Retrofit', category: 'Networking'),

      // Firebase
      SkillModel(
        id: 'firebase-auth',
        name: 'Firebase Auth',
        category: 'Firebase',
      ),
      SkillModel(id: 'firestore', name: 'Firestore', category: 'Firebase'),
      SkillModel(
        id: 'fcm',
        name: 'Cloud Messaging (FCM)',
        category: 'Firebase',
      ),

      // Maps & Tracking
      SkillModel(
        id: 'google-maps',
        name: 'Google Maps',
        category: 'Maps & Tracking',
      ),
      SkillModel(
        id: 'live-tracking',
        name: 'Live Tracking',
        category: 'Maps & Tracking',
      ),
      SkillModel(
        id: 'bg-location',
        name: 'Background Location',
        category: 'Maps & Tracking',
      ),

      // Local Storage
      SkillModel(id: 'hive', name: 'Hive', category: 'Local Storage'),
      SkillModel(id: 'sqlite', name: 'SQLite', category: 'Local Storage'),
      SkillModel(
        id: 'shared-preferences',
        name: 'SharedPreferences',
        category: 'Local Storage',
      ),

      // Testing
      SkillModel(id: 'unit-testing', name: 'Unit Testing', category: 'Testing'),
      SkillModel(
        id: 'widget-testing',
        name: 'Widget Testing',
        category: 'Testing',
      ),
      SkillModel(id: 'mockito', name: 'Mockito', category: 'Testing'),

      // Tools & DevOps
      SkillModel(id: 'git', name: 'Git', category: 'Tools & DevOps'),
      SkillModel(id: 'github', name: 'GitHub', category: 'Tools & DevOps'),
      SkillModel(
        id: 'github-actions',
        name: 'GitHub Actions',
        category: 'Tools & DevOps',
      ),
      SkillModel(id: 'cicd', name: 'CI/CD', category: 'Tools & DevOps'),
      SkillModel(id: 'postman', name: 'Postman', category: 'Tools & DevOps'),
      SkillModel(
        id: 'sonarqube',
        name: 'SonarQube',
        category: 'Tools & DevOps',
      ),
      SkillModel(
        id: 'flutter-flavors',
        name: 'Flutter Flavors',
        category: 'Tools & DevOps',
      ),

      // Workflow
      SkillModel(id: 'agile', name: 'Agile', category: 'Workflow'),
      SkillModel(id: 'scrum', name: 'Scrum', category: 'Workflow'),
    ];
  }

  /// Groups skills by category for organized section presentation.
  Map<String, List<SkillModel>> getSkillsByCategory() {
    final map = <String, List<SkillModel>>{};
    for (final skill in getSkills()) {
      map.putIfAbsent(skill.category, () => []).add(skill);
    }
    return map;
  }
}
