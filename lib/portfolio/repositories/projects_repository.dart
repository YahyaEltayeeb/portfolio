import '../../core/constants/app_assets.dart';
import '../models/project_model.dart';

class ProjectsRepository {
  const ProjectsRepository();

  List<ProjectModel> getProjects() {
    return const [
      // 1. Zadna Groceries (Production App)
      ProjectModel(
        id: 'zadna-groceries',
        title: 'Zadna Groceries',
        shortDescription:
            'Production e-groceries application delivering seamless grocery ordering and real-time delivery tracking.',
        fullDescription:
            'A full-scale production grocery mobile application serving active customers across Egypt. '
            'Engineered using Clean Architecture and BLoC/Cubit for scalable, testable state management. '
            'Features include live order tracking on Google Maps, push notifications via Firebase Cloud Messaging, '
            'secure payment integrations, and offline product caching for high-speed performance.',
        myRole:
            'Flutter Developer - Clean Architecture implementation, state management, payment integrations, and App Store publication.',
        keyFeatures: [
          'Clean Architecture with BLoC & Cubit',
          'Google Maps Real-Time Order Tracking',
          'Payment Gateway Integrations',
          'Firebase Cloud Messaging Push Notifications',
          'Offline Caching & Fast Search',
        ],
        techStack: [
          'Flutter',
          'Dart',
          'Clean Architecture',
          'BLoC/Cubit',
          'Google Maps',
          'Firebase',
          'REST APIs',
        ],
        coverAsset: AppAssets.zadnaGroceriesCover,
        isProduction: true,
        appStoreUrl:
            'https://apps.apple.com/eg/app/zadna-%D8%B2%D8%A7%D8%AF%D9%86%D8%A7-groceries/id6793952655',
        playStoreUrl: null, // TODO: Add Google Play URL when available
        githubUrl: null, // Private production codebase
        liveDemoUrl: null,
      ),

      // 2. Zadna Delivery (Production App)
      ProjectModel(
        id: 'zadna-delivery',
        title: 'Zadna Delivery',
        shortDescription:
            'Production courier application with background location services and live route navigation.',
        fullDescription:
            'A robust logistics and delivery application built for couriers and drivers in active production. '
            'Engineered with reliable background location synchronization, Google Maps routing, real-time order acceptance lifecycles, '
            'and resilient network error handling to ensure seamless fulfillment of orders in real time.',
        myRole:
            'Flutter Developer - Background location services, live routing implementation, state management, and App Store release.',
        keyFeatures: [
          'Background Location Tracking',
          'Google Maps Route Guidance',
          'Real-Time Order Dispatch Lifecycle',
          'Clean Architecture & Cubit',
          'Push Notifications & Alerts',
        ],
        techStack: [
          'Flutter',
          'Dart',
          'Clean Architecture',
          'BLoC/Cubit',
          'Background Location',
          'Google Maps',
          'REST APIs',
        ],
        coverAsset: AppAssets.zadnaDeliveryCover,
        isProduction: true,
        appStoreUrl:
            'https://apps.apple.com/eg/app/zadna-delivery/id6798372783',
        playStoreUrl: null, // TODO: Add Google Play URL when available
        githubUrl: null, // Private production codebase
        liveDemoUrl: null,
      ),

      // 3. Super Fitness
      ProjectModel(
        id: 'super-fitness',
        title: 'Super Fitness',
        shortDescription:
            'Comprehensive fitness and workout companion application with exercise tracking and progress analytics.',
        fullDescription:
            'A modern fitness tracking mobile application designed to help users plan workouts, track fitness routines, '
            'monitor nutritional milestones, and visualize performance metrics through responsive, interactive charts. '
            'Built with Clean Architecture, local storage for offline workouts, and clean Cubit state management.',
        myRole:
            'Lead Developer - End-to-end architecture, UI implementation, local data caching, and custom analytics.',
        keyFeatures: [
          'Custom Workout Routines & Exercise Library',
          'Progress & Milestone Analytics',
          'Clean Architecture & Cubit',
          'Local Database Caching',
          'Responsive Fluid UI',
        ],
        techStack: [
          'Flutter',
          'Dart',
          'Clean Architecture',
          'Cubit',
          'SQLite/Hive',
          'REST APIs',
        ],
        coverAsset: AppAssets.superFitnessCover,
        isProduction: false,
        appStoreUrl: null,
        playStoreUrl: null,
        githubUrl: 'https://github.com/YahyaEltayeeb/Super_Fitness_App',
        liveDemoUrl: null,
      ),

      // 4. Flowery E-Commerce
      ProjectModel(
        id: 'flowery-ecommerce',
        title: 'Flowery E-Commerce',
        shortDescription:
            'Specialized floral and gifting e-commerce app with catalog browsing, shopping cart, and checkout flow.',
        fullDescription:
            'An elegant floral e-commerce application delivering an intuitive mobile shopping experience with product categorization, '
            'dynamic search & filtering, wishlist, animated cart management, and multi-step checkout. '
            'Built using Clean Architecture with BLoC/Cubit, Retrofit, and Dio for high-speed networking.',
        myRole:
            'Flutter Developer - Modular architecture, custom animations, shopping cart state management, and API integration.',
        keyFeatures: [
          'Product Catalog & Dynamic Search',
          'Animated Cart & Wishlist',
          'Multi-Step Checkout Flow',
          'BLoC/Cubit State Management',
          'Clean Architecture with Retrofit',
        ],
        techStack: [
          'Flutter',
          'Dart',
          'Clean Architecture',
          'BLoC/Cubit',
          'Retrofit',
          'Dio',
        ],
        coverAsset: AppAssets.floweryEcommerceCover,
        isProduction: false,
        appStoreUrl: null,
        playStoreUrl: null,
        githubUrl: 'https://github.com/YahyaEltayeeb/Flowery-E-Commerce-App',
        liveDemoUrl: null,
      ),

      // 5. Flowery Tracking
      ProjectModel(
        id: 'flowery-tracking',
        title: 'Flowery Tracking',
        shortDescription:
            'Real-time delivery driver and logistics tracking app companion for the Flowery platform.',
        fullDescription:
            'A companion delivery tracking application engineered to track real-time delivery status, driver coordinates, '
            'and order handoff updates using Google Maps SDK and live geolocation streams. '
            'Employs Clean Architecture and unit tests to ensure high delivery accuracy.',
        myRole:
            'Flutter Developer - Real-time geolocation stream handling, Google Maps integration, and courier lifecycle logic.',
        keyFeatures: [
          'Live Driver Location Streaming',
          'Google Maps Directions & Polylines',
          'Real-Time Status Updates',
          'Clean Architecture',
          'Unit Tested State Logic',
        ],
        techStack: [
          'Flutter',
          'Dart',
          'Clean Architecture',
          'BLoC',
          'Google Maps',
          'Geolocation',
        ],
        coverAsset: AppAssets.floweryTrackingCover,
        isProduction: false,
        appStoreUrl: null,
        playStoreUrl: null,
        githubUrl: 'https://github.com/YahyaEltayeeb/Flowery-tracking-app',
        liveDemoUrl: null,
      ),

      // 6. Exam App
      ProjectModel(
        id: 'exam-app',
        title: 'Exam App',
        shortDescription:
            'Interactive examination and assessment testing platform with timers and real-time score grading.',
        fullDescription:
            'An academic examination and assessment testing mobile application supporting timed quizzes, dynamic question generation, '
            'instant score breakdown, and historical result analysis. '
            'Features comprehensive unit test coverage and robust state management for accurate timer synchronization.',
        myRole:
            'Flutter Developer - Test engine logic, timer state management, quiz validation, and UI components.',
        keyFeatures: [
          'Timed Quiz Sessions with Auto-Submission',
          'Dynamic Question Bank & Filtering',
          'Instant Score Breakdown & Review',
          'Clean Architecture',
          'Comprehensive Unit Tests',
        ],
        techStack: [
          'Flutter',
          'Dart',
          'Clean Architecture',
          'Cubit',
          'Unit Testing',
          'REST APIs',
        ],
        coverAsset: AppAssets.examAppCover,
        isProduction: false,
        appStoreUrl: null,
        playStoreUrl: null,
        githubUrl: 'https://github.com/YahyaEltayeeb/examapp',
        liveDemoUrl: null,
      ),
    ];
  }
}
