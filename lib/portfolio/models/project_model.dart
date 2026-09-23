import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_links.dart';
import '../../core/constants/app_strings.dart';

enum ProjectActionType { appStore, playStore, gitHub, liveDemo }

class ProjectAction {
  final ProjectActionType type;
  final String label;
  final String url;
  final FaIconData icon;

  const ProjectAction({
    required this.type,
    required this.label,
    required this.url,
    required this.icon,
  });
}

class ProjectModel {
  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String myRole;
  final List<String> keyFeatures;
  final List<String> techStack;
  final String coverAsset;
  final List<String> screenshotAssets;
  final double coverAspectRatio;
  final double screenshotAspectRatio;
  final String? appStoreUrl;
  final String? playStoreUrl;
  final String? githubUrl;
  final String? liveDemoUrl;
  final bool isProduction;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.myRole,
    required this.keyFeatures,
    required this.techStack,
    required this.coverAsset,
    this.screenshotAssets = const [],
    this.coverAspectRatio = 16 / 9,
    this.screenshotAspectRatio = 16 / 9,
    this.appStoreUrl,
    this.playStoreUrl,
    this.githubUrl,
    this.liveDemoUrl,
    this.isProduction = false,
  });

  /// Resolves the single highest-priority external action according to:
  /// 1. App Store
  /// 2. Play Store
  /// 3. GitHub
  /// 4. Live Demo
  ///
  /// Returns null if no valid URL exists.
  ProjectAction? get primaryExternalAction {
    if (AppLinks.isValid(appStoreUrl)) {
      return ProjectAction(
        type: ProjectActionType.appStore,
        label: AppStrings.appStore,
        url: appStoreUrl!,
        icon: FontAwesomeIcons.appStoreIos,
      );
    }
    if (AppLinks.isValid(playStoreUrl)) {
      return ProjectAction(
        type: ProjectActionType.playStore,
        label: AppStrings.playStore,
        url: playStoreUrl!,
        icon: FontAwesomeIcons.googlePlay,
      );
    }
    if (AppLinks.isValid(githubUrl)) {
      return ProjectAction(
        type: ProjectActionType.gitHub,
        label: AppStrings.gitHub,
        url: githubUrl!,
        icon: FontAwesomeIcons.github,
      );
    }
    if (AppLinks.isValid(liveDemoUrl)) {
      return ProjectAction(
        type: ProjectActionType.liveDemo,
        label: AppStrings.liveDemo,
        url: liveDemoUrl!,
        icon: FontAwesomeIcons.globe,
      );
    }
    return null;
  }

  /// Returns all valid external actions for display on the Project Details page.
  List<ProjectAction> get allValidActions {
    final actions = <ProjectAction>[];

    if (AppLinks.isValid(appStoreUrl)) {
      actions.add(
        ProjectAction(
          type: ProjectActionType.appStore,
          label: AppStrings.appStore,
          url: appStoreUrl!,
          icon: FontAwesomeIcons.appStoreIos,
        ),
      );
    }
    if (AppLinks.isValid(playStoreUrl)) {
      actions.add(
        ProjectAction(
          type: ProjectActionType.playStore,
          label: AppStrings.playStore,
          url: playStoreUrl!,
          icon: FontAwesomeIcons.googlePlay,
        ),
      );
    }
    if (AppLinks.isValid(githubUrl)) {
      actions.add(
        ProjectAction(
          type: ProjectActionType.gitHub,
          label: AppStrings.gitHub,
          url: githubUrl!,
          icon: FontAwesomeIcons.github,
        ),
      );
    }
    if (AppLinks.isValid(liveDemoUrl)) {
      actions.add(
        ProjectAction(
          type: ProjectActionType.liveDemo,
          label: AppStrings.liveDemo,
          url: liveDemoUrl!,
          icon: FontAwesomeIcons.globe,
        ),
      );
    }

    return actions;
  }
}
