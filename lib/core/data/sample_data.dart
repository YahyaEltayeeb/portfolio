import 'package:flutter/material.dart';
import '../../models/district_model.dart';
import '../../models/project_model.dart';
import '../../models/skill_model.dart';
import '../constants/app_colors.dart';

class SampleData {
  SampleData._();

  static final List<DistrictModel> districts = [
    DistrictModel(
      id: 'commerce',
      name: 'COMMERCE\nDISTRICT',
      description:
          'Complete e-commerce solutions with multi vendor capabilities and powerful management tools.',
      icon: Icons.shopping_bag_outlined,
      accentColor: AppColors.neonOrange,
      highlights: [
        'Multi Vendor System',
        'Product Management',
        'Cart & Checkout',
        'Orders & Reviews',
      ],
      projects: [
        const ProjectModel(
          id: 'ecommerce-app',
          title: 'E-Commerce App',
          subtitle: 'Customer App',
          description:
              'Beautiful e-commerce app with modern UI/UX and seamless shopping experience.',
          features: [
            'Product Browsing & Search',
            'Shopping Cart & Wishlist',
            'Secure Checkout',
            'Order Tracking',
            'Product Reviews & Ratings',
          ],
          techStack: ['Flutter', 'Firebase', 'REST API'],
          githubUrl: 'https://github.com/yahya/ecommerce-app',
          liveDemoUrl: 'https://ecommerce-demo.app',
        ),
        const ProjectModel(
          id: 'zadana-vendor',
          title: 'Zadana Multi Vendor',
          subtitle: 'Vendor System',
          description:
              'Complete multi vendor marketplace solution with powerful admin panel and vendor dashboard.',
          features: [
            'Vendor Registration & Verification',
            'Product & Order Management',
            'Commission System',
            'Real-time Analytics',
            'Multiple Payment Methods',
          ],
          techStack: ['Flutter', 'Firebase', 'Web'],
          githubUrl: 'https://github.com/yahya/zadana',
          liveDemoUrl: 'https://zadana-demo.app',
        ),
      ],
      mapPosition: const Offset(0.72, 0.25),
    ),
    DistrictModel(
      id: 'education',
      name: 'EDUCATION\nCENTER',
      description:
          'Online examination system with advanced features and analytics.',
      icon: Icons.school_outlined,
      accentColor: AppColors.neonGreen,
      highlights: [
        'Online Exams',
        'Question Bank',
        'Results & Analytics',
        'Timer & Reports',
      ],
      projects: [
        const ProjectModel(
          id: 'exam-app',
          title: 'Exam App',
          subtitle: 'Online Examination',
          description:
              'Online examination system with advanced features and analytics.',
          features: [
            'Question Bank Management',
            'Timed Examinations',
            'Instant Results & Analytics',
            'Progress Tracking',
            'Multiple Question Types',
          ],
          techStack: ['Flutter', 'Firebase', 'Provider'],
          githubUrl: 'https://github.com/yahya/exam-app',
        ),
      ],
      mapPosition: const Offset(0.2, 0.2),
    ),
    DistrictModel(
      id: 'delivery',
      name: 'DELIVERY\nHUB',
      description:
          'Real-time delivery and tracking system for efficient logistics management.',
      icon: Icons.local_shipping_outlined,
      accentColor: AppColors.neonCyan,
      highlights: [
        'Order Management',
        'Real-time Tracking',
        'Driver App',
        'Delivery Analytics',
      ],
      projects: [
        const ProjectModel(
          id: 'delivery-app',
          title: 'Delivery App',
          subtitle: 'Logistics Solution',
          description:
              'Driver application for managing deliveries and real-time order updates.',
          features: [
            'Real-time GPS Tracking',
            'Order Queue Management',
            'Route Optimization',
            'Delivery Confirmation',
            'Earnings Dashboard',
          ],
          techStack: ['Flutter', 'Google Maps', 'Firebase'],
          githubUrl: 'https://github.com/yahya/delivery-app',
        ),
        const ProjectModel(
          id: 'tracking-system',
          title: 'Tracking System',
          subtitle: 'Real-time Tracking',
          description:
              'Real-time tracking with route visualization and status updates.',
          features: [
            'Live Location Sharing',
            'Route Visualization',
            'ETA Calculations',
            'Status Notifications',
          ],
          techStack: ['Flutter', 'Firebase', 'Maps API'],
        ),
      ],
      mapPosition: const Offset(0.15, 0.65),
    ),
    DistrictModel(
      id: 'fitness',
      name: 'FITNESS\nCENTER',
      description:
          'Health and fitness tracking app to monitor workouts, nutrition and progress.',
      icon: Icons.fitness_center_outlined,
      accentColor: AppColors.neonPink,
      highlights: [
        'Workout Plans',
        'Nutrition Tracking',
        'Progress Analytics',
        'Body Metrics',
      ],
      projects: [
        const ProjectModel(
          id: 'fitness-app',
          title: 'Fitness App',
          subtitle: 'Score Tracking',
          description:
              'Health and fitness tracking app to monitor workouts, nutrition and progress.',
          features: [
            'Custom Workout Plans',
            'Nutrition Tracking',
            'Progress Analytics',
            'Body Measurements',
            'Achievement System',
          ],
          techStack: ['Flutter', 'Provider', 'SQLite'],
          githubUrl: 'https://github.com/yahya/fitness-app',
        ),
      ],
      mapPosition: const Offset(0.75, 0.7),
    ),
    DistrictModel(
      id: 'ai-lab',
      name: 'AI RESEARCH\nLAB',
      description:
          'Graduation project focused on computer vision and AI-based exam monitoring.',
      icon: Icons.psychology_outlined,
      accentColor: AppColors.neonPurple,
      highlights: [
        'Computer Vision',
        'Exam Monitoring',
        'AI Detection System',
      ],
      projects: [
        const ProjectModel(
          id: 'ai-monitoring',
          title: 'AI Monitoring System',
          subtitle: 'Graduation Project',
          description:
              'Computer vision based exam monitoring system using AI for suspicious behavior detection.',
          features: [
            'Face Detection',
            'Attention Tracking',
            'Suspicious Behavior Detection',
            'Real-time Alerts',
            'Report Generation',
          ],
          techStack: ['Flutter', 'Python', 'TensorFlow', 'OpenCV'],
          githubUrl: 'https://github.com/yahya/ai-monitoring',
        ),
      ],
      mapPosition: const Offset(0.5, 0.12),
    ),
  ];

  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      name: 'Mobile Development',
      skills: [
        SkillModel(name: 'Flutter', category: 'Mobile', proficiency: 0.95),
        SkillModel(name: 'Dart', category: 'Mobile', proficiency: 0.92),
        SkillModel(
            name: 'State Management', category: 'Mobile', proficiency: 0.88),
        SkillModel(
            name: 'Responsive Design', category: 'Mobile', proficiency: 0.90),
      ],
    ),
    SkillCategory(
      name: 'Backend & Cloud',
      skills: [
        SkillModel(name: 'Firebase', category: 'Backend', proficiency: 0.88),
        SkillModel(name: 'REST APIs', category: 'Backend', proficiency: 0.85),
        SkillModel(name: 'Git', category: 'Backend', proficiency: 0.85),
        SkillModel(name: 'CI/CD', category: 'Backend', proficiency: 0.70),
      ],
    ),
    SkillCategory(
      name: 'Design & Tools',
      skills: [
        SkillModel(name: 'UI/UX Design', category: 'Design', proficiency: 0.80),
        SkillModel(name: 'Figma', category: 'Design', proficiency: 0.75),
        SkillModel(
            name: 'Clean Architecture',
            category: 'Design',
            proficiency: 0.85),
        SkillModel(name: 'Problem Solving', category: 'Design', proficiency: 0.88),
      ],
    ),
  ];
}
