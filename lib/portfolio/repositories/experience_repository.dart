import '../models/experience_model.dart';

class ExperienceRepository {
  const ExperienceRepository();

  List<ExperienceModel> getExperiences() {
    return const [
      // 1. Black Falcons
      ExperienceModel(
        id: 'black-falcons',
        title: 'Flutter Developer',
        company: 'Black Falcons',
        period: 'March 2026 – Present',
        location: 'Remote',
        responsibilities: [
          'Built and published Zadna Groceries and Zadna Delivery to the App Store.',
          'Applied Clean Architecture and BLoC/Cubit for scalable, maintainable codebase.',
          'Integrated RESTful APIs, payment gateways, and push notifications via FCM.',
          'Implemented Google Maps, live tracking, and resilient background location services.',
        ],
        technologies: [
          'Flutter',
          'Dart',
          'Clean Architecture',
          'BLoC/Cubit',
          'Google Maps',
          'Background Location',
          'FCM',
          'Payment Gateway',
        ],
      ),

      // 2. Black Horse Courses
      ExperienceModel(
        id: 'black-horse-courses',
        title: 'Flutter Instructor',
        company: 'Black Horse Courses',
        period: 'February 2026 – June 2026',
        location: 'On-site',
        responsibilities: [
          'Delivered comprehensive, hands-on Flutter and Dart training to aspiring developers.',
          'Covered OOP principles, responsive UI development, state management, REST APIs, and Firebase.',
          'Mentored students through practical coding exercises, code reviews, and real-world projects.',
        ],
        technologies: [
          'Flutter',
          'Dart',
          'OOP',
          'State Management',
          'REST APIs',
          'Firebase',
          'Mentorship',
        ],
      ),

      // 3. Elevate Tech
      ExperienceModel(
        id: 'elevate-tech',
        title: 'Flutter Developer Intern',
        company: 'Elevate Tech',
        period: 'July 2025 – December 2025',
        location: 'Remote',
        responsibilities: [
          'Built and contributed to more than four production-grade Flutter applications.',
          'Employed Clean Architecture and BLoC/Cubit for modular code separation.',
          'Integrated Retrofit APIs, payment processing, and Google Maps location tracking.',
          'Wrote Unit and Widget Tests, maintaining a 75% test coverage standard.',
          'Collaborated actively in Agile/Scrum sprints and CI/CD deployment pipelines.',
        ],
        technologies: [
          'Flutter',
          'Dart',
          'Clean Architecture',
          'BLoC/Cubit',
          'Retrofit',
          'Unit Testing',
          'Widget Testing',
          'Agile/Scrum',
          'CI/CD',
        ],
      ),
    ];
  }
}
