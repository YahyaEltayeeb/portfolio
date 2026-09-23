import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/portfolio/models/project_model.dart';

void main() {
  group('ProjectModel External Action Priority Tests', () {
    test('returns App Store as primary action when all URLs are present', () {
      const project = ProjectModel(
        id: 'test',
        title: 'Test',
        shortDescription: 'desc',
        fullDescription: 'full',
        myRole: 'role',
        keyFeatures: [],
        techStack: [],
        coverAsset: 'cover.webp',
        appStoreUrl: 'https://apps.apple.com/app/test',
        playStoreUrl: 'https://play.google.com/store/apps/test',
        githubUrl: 'https://github.com/user/test',
        liveDemoUrl: 'https://demo.com',
      );

      final primary = project.primaryExternalAction;
      expect(primary, isNotNull);
      expect(primary!.type, equals(ProjectActionType.appStore));
      expect(primary.label, equals('App Store'));
    });

    test('falls back to Play Store when App Store is null', () {
      const project = ProjectModel(
        id: 'test',
        title: 'Test',
        shortDescription: 'desc',
        fullDescription: 'full',
        myRole: 'role',
        keyFeatures: [],
        techStack: [],
        coverAsset: 'cover.webp',
        appStoreUrl: null,
        playStoreUrl: 'https://play.google.com/store/apps/test',
        githubUrl: 'https://github.com/user/test',
        liveDemoUrl: 'https://demo.com',
      );

      final primary = project.primaryExternalAction;
      expect(primary, isNotNull);
      expect(primary!.type, equals(ProjectActionType.playStore));
      expect(primary.label, equals('Play Store'));
    });

    test('falls back to GitHub when App Store and Play Store are null', () {
      const project = ProjectModel(
        id: 'test',
        title: 'Test',
        shortDescription: 'desc',
        fullDescription: 'full',
        myRole: 'role',
        keyFeatures: [],
        techStack: [],
        coverAsset: 'cover.webp',
        appStoreUrl: null,
        playStoreUrl: null,
        githubUrl: 'https://github.com/user/test',
        liveDemoUrl: 'https://demo.com',
      );

      final primary = project.primaryExternalAction;
      expect(primary, isNotNull);
      expect(primary!.type, equals(ProjectActionType.gitHub));
      expect(primary.label, equals('GitHub'));
    });

    test('falls back to Live Demo when only Live Demo is present', () {
      const project = ProjectModel(
        id: 'test',
        title: 'Test',
        shortDescription: 'desc',
        fullDescription: 'full',
        myRole: 'role',
        keyFeatures: [],
        techStack: [],
        coverAsset: 'cover.webp',
        appStoreUrl: null,
        playStoreUrl: null,
        githubUrl: null,
        liveDemoUrl: 'https://demo.com',
      );

      final primary = project.primaryExternalAction;
      expect(primary, isNotNull);
      expect(primary!.type, equals(ProjectActionType.liveDemo));
      expect(primary.label, equals('Live Demo'));
    });

    test('returns null when all external URLs are null or empty', () {
      const project = ProjectModel(
        id: 'test',
        title: 'Test',
        shortDescription: 'desc',
        fullDescription: 'full',
        myRole: 'role',
        keyFeatures: [],
        techStack: [],
        coverAsset: 'cover.webp',
        appStoreUrl: null,
        playStoreUrl: '',
        githubUrl: '   ',
        liveDemoUrl: null,
      );

      expect(project.primaryExternalAction, isNull);
      expect(project.allValidActions, isEmpty);
    });

    test('allValidActions returns only valid non-empty URLs', () {
      const project = ProjectModel(
        id: 'test',
        title: 'Test',
        shortDescription: 'desc',
        fullDescription: 'full',
        myRole: 'role',
        keyFeatures: [],
        techStack: [],
        coverAsset: 'cover.webp',
        appStoreUrl: 'https://apps.apple.com/app/test',
        playStoreUrl: null,
        githubUrl: 'https://github.com/user/test',
        liveDemoUrl: '',
      );

      final valid = project.allValidActions;
      expect(valid.length, equals(2));
      expect(
        valid.map((a) => a.type),
        containsAll([ProjectActionType.appStore, ProjectActionType.gitHub]),
      );
    });
  });
}
