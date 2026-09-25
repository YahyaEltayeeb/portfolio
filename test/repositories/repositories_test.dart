import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/portfolio/models/social_link_model.dart';
import 'package:portfolio/portfolio/repositories/experience_repository.dart';
import 'package:portfolio/portfolio/repositories/projects_repository.dart';
import 'package:portfolio/portfolio/repositories/skills_repository.dart';
import 'package:portfolio/portfolio/repositories/social_links_repository.dart';
import 'package:portfolio/portfolio/repositories/workflow_repository.dart';

void main() {
  group('ProjectsRepository Data & Asset Tests', () {
    const repository = ProjectsRepository();
    final projects = repository.getProjects();

    test('contains exactly the 6 approved projects with correct naming', () {
      expect(projects.length, equals(6));
      final titles = projects.map((p) => p.title).toList();
      expect(
        titles,
        equals([
          'Zadna Groceries',
          'Zadna Delivery',
          'Super Fitness',
          'Flowery E-Commerce',
          'Flowery Tracking',
          'Exam App',
        ]),
      );
    });

    test('Zadna projects are production apps with valid App Store URLs', () {
      final zadnaGroceries = projects.firstWhere(
        (p) => p.id == 'zadna-groceries',
      );
      final zadnaDelivery = projects.firstWhere(
        (p) => p.id == 'zadna-delivery',
      );

      expect(zadnaGroceries.isProduction, isTrue);
      expect(zadnaGroceries.appStoreUrl, isNotNull);
      expect(zadnaGroceries.githubUrl, isNull);

      expect(zadnaDelivery.isProduction, isTrue);
      expect(zadnaDelivery.appStoreUrl, isNotNull);
      expect(zadnaDelivery.githubUrl, isNull);
    });

    test('GitHub projects have valid GitHub URLs and no store links', () {
      final githubProjects = projects.where((p) => !p.isProduction).toList();
      expect(githubProjects.length, equals(4));

      for (final p in githubProjects) {
        expect(p.isProduction, isFalse);
        expect(p.appStoreUrl, isNull);
        expect(p.playStoreUrl, isNull);
        expect(p.githubUrl, isNotNull);
        expect(
          p.githubUrl!.startsWith('https://github.com/YahyaEltayeeb/'),
          isTrue,
        );
      }
    });

    test('all projects have cover.png as coverAsset', () {
      for (final p in projects) {
        expect(p.coverAsset.endsWith('/cover.png'), isTrue);
        expect(
          File(p.coverAsset).existsSync(),
          isTrue,
          reason: 'Cover file missing: ${p.coverAsset}',
        );
      }
    });

    test('screenshot counts match detected assets per project', () {
      final zadnaGroceries = projects.firstWhere(
        (p) => p.id == 'zadna-groceries',
      );
      final zadnaDelivery = projects.firstWhere(
        (p) => p.id == 'zadna-delivery',
      );
      final superFitness = projects.firstWhere((p) => p.id == 'super-fitness');
      final floweryEcommerce = projects.firstWhere(
        (p) => p.id == 'flowery-ecommerce',
      );
      final floweryTracking = projects.firstWhere(
        (p) => p.id == 'flowery-tracking',
      );
      final examApp = projects.firstWhere((p) => p.id == 'exam-app');

      expect(zadnaGroceries.screenshotAssets.length, equals(7));
      expect(zadnaDelivery.screenshotAssets.length, equals(5));
      expect(superFitness.screenshotAssets.length, equals(9));
      expect(floweryEcommerce.screenshotAssets.length, equals(11));
      expect(floweryTracking.screenshotAssets.length, equals(10));
      expect(examApp.screenshotAssets.length, equals(5));
    });

    test('screenshots preserve strict numerical order', () {
      for (final p in projects) {
        for (int i = 0; i < p.screenshotAssets.length; i++) {
          final asset = p.screenshotAssets[i];
          final expectedNum = (i + 1).toString().padLeft(2, '0');
          expect(
            asset.contains(expectedNum),
            isTrue,
            reason: 'Asset $asset expected to contain $expectedNum',
          );
          expect(
            File(asset).existsSync(),
            isTrue,
            reason: 'Screenshot file missing: $asset',
          );
        }
      }
    });
  });

  group('SocialLinksRepository Data Tests', () {
    const repository = SocialLinksRepository();
    final links = repository.getSocialLinks();

    test('contains LinkedIn, GitHub, WhatsApp, and Email', () {
      expect(links.length, equals(4));
      final platforms = links.map((l) => l.platform).toList();
      expect(
        platforms,
        containsAll([
          SocialPlatform.linkedIn,
          SocialPlatform.gitHub,
          SocialPlatform.whatsApp,
          SocialPlatform.email,
        ]),
      );
    });

    test('URLs match the real user endpoints and are valid', () {
      final linkedIn = links.firstWhere(
        (l) => l.platform == SocialPlatform.linkedIn,
      );
      final gitHub = links.firstWhere(
        (l) => l.platform == SocialPlatform.gitHub,
      );
      final whatsApp = links.firstWhere(
        (l) => l.platform == SocialPlatform.whatsApp,
      );
      final email = links.firstWhere((l) => l.platform == SocialPlatform.email);

      expect(
        linkedIn.url,
        equals('https://www.linkedin.com/in/yahya-mohamed-yahyamohamed/'),
      );
      expect(gitHub.url, equals('https://github.com/YahyaEltayeeb'));
      expect(whatsApp.url, equals('https://wa.me/201289078927'));
      expect(
        email.url,
        equals(
          'https://mail.google.com/mail/?view=cm&fs=1&to=yahya.mobiledev@gmail.com',
        ),
      );
    });
  });

  group('SkillsRepository Data Tests', () {
    const repository = SkillsRepository();
    final skills = repository.getSkills();

    test('contains skills across all expected categories', () {
      final categories = skills.map((s) => s.category).toSet();
      expect(
        categories,
        containsAll([
          'Development',
          'Architecture',
          'State Management',
          'Networking',
          'Firebase',
          'Maps & Tracking',
          'Local Storage',
          'Testing',
          'Tools & DevOps',
          'Workflow',
        ]),
      );
    });

    test('getSkillsByCategory correctly groups items', () {
      final grouped = repository.getSkillsByCategory();
      expect(grouped.containsKey('Development'), isTrue);
      expect(
        grouped['Development']!.map((s) => s.name),
        containsAll(['Dart', 'Flutter']),
      );
      expect(
        grouped['State Management']!.map((s) => s.name),
        containsAll(['BLoC', 'Cubit', 'Provider']),
      );
    });
  });

  group('ExperienceRepository Data Tests', () {
    const repository = ExperienceRepository();
    final experiences = repository.getExperiences();

    test('contains exactly the 3 career milestones', () {
      expect(experiences.length, equals(3));
      expect(experiences[0].company, equals('Black Falcons'));
      expect(experiences[1].company, equals('Black Horse Courses'));
      expect(experiences[2].company, equals('Elevate Tech'));
    });
  });

  group('WorkflowRepository Data Tests', () {
    const repository = WorkflowRepository();
    final steps = repository.getSteps();

    test('contains the 5 sequential process milestones', () {
      expect(steps.length, equals(5));
      for (int i = 0; i < steps.length; i++) {
        expect(steps[i].stepNumber, equals(i + 1));
      }
      expect(steps[0].title, equals('Understand Requirements'));
      expect(steps[1].title, equals('Plan Architecture'));
      expect(steps[2].title, equals('Build & Integrate'));
      expect(steps[3].title, equals('Test & Optimize'));
      expect(steps[4].title, equals('Publish & Support'));
    });
  });
}
